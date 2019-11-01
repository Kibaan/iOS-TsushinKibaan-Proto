//
//  Connection.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTP通信のライフサイクル
/// 通信に必要な各種モジュールを取りまとめ、通信処理の実行と各種コールバックやリスナーの呼び出しを行う
///
/// The lifecycle of a HTTP connection.
///
///
open class Connection<ResponseModel>: ConnectionTask {

    public let requestSpec: RequestSpec
    public let parseResponse: (Response) throws -> ResponseModel
    public let isValidResponse: (Response) -> Bool

    public var listeners: [ConnectionListener] = []
    public var responseListeners: [ConnectionResponseListener] = []
    public var errorListeners: [ConnectionErrorListener] = []

    public var connector: HTTPConnector = DefaultHTTPConnector()
    public var urlEncoder: URLEncoder = DefaultURLEncoder()
    public var isCancelled = false
    /// startの引数に渡したコールバックをメインスレッドで呼び出すか
    public var callbackInMainThread = true

    var onSuccess: ((ResponseModel) -> Void)?
    var onError: ((ConnectionError, Response?, ResponseModel?) -> Void)?
    var onEnd: (() -> Void)?

    public var latestRequest: Request?

    public weak var holder = ConnectionHolder.shared

    // TODO initにstartを統合するか？ 使いやすい呼び出しIFを考える
    init<T: ResponseSpec>(requestSpec: RequestSpec, responseSpec: T) where T.ResponseModel == ResponseModel {
        self.requestSpec = requestSpec
        self.parseResponse = responseSpec.parseResponse
        self.isValidResponse = responseSpec.isValidResponse
    }

    init<T: ConnectionSpec>(connectionSpec: T) where T.ResponseModel == ResponseModel {
        self.requestSpec = connectionSpec
        self.parseResponse = connectionSpec.parseResponse
        self.isValidResponse = connectionSpec.isValidResponse
    }

    func addListener(_ listener: ConnectionListener) { listeners.append(listener) }
    func addResponseListener(_ listener: ConnectionResponseListener) { responseListeners.append(listener) }
    func addErrorListener(_ listener: ConnectionErrorListener) { errorListeners.append(listener) }

    func removeListener(_ listener: ConnectionListener) { listeners.removeAll { $0 === listener } }
    func removeResponseListener(_ listener: ConnectionResponseListener) { responseListeners.removeAll { $0 === listener } }
    func removeErrorListener(_ listener: ConnectionErrorListener) { errorListeners.removeAll { $0 === listener } }

    /// 処理を開始する
    ///
    /// - Parameters:
    ///   - onSuccess: パラメータの説明
    ///   - onError: パラメータの説明
    ///   - onEnd: パラメータの説明
    ///   - callbackInMainThread: パラメータの説明
    func start(onSuccess: ((ResponseModel) -> Void)? = nil,
               onError: ((ConnectionError, Response?, ResponseModel?) -> Void)? = nil,
               onEnd: (() -> Void)? = nil) {
        self.onSuccess = onSuccess
        self.onError = onError
        self.onEnd = onEnd

        connect()
    }

    // TODO Listnerにキャンセルやリトライするための制御オブジェクトを渡す必要がある
    
    /// 通信処理を開始する
    func connect(request: Request? = nil) {
        guard let url = makeURL(baseURL: requestSpec.url, query: requestSpec.urlQuery, encoder: urlEncoder) else {
            handleError(.invalidURL)
            return
        }

        // リクエスト作成
        let request = request ?? Request(url: url,
                                         method: requestSpec.httpMethod,
                                         body: requestSpec.makePostData(),
                                         headers: requestSpec.headers)

        listeners.forEach {
            $0.onStart(request: request)
        }

        // このインスタンスが通信完了まで開放されないよう保持する必要がある
        holder?.add(connection: self)

        print("[\(requestSpec.httpMethod.stringValue)] \(url)")

        // 通信する
        connector.execute(request: request, complete: { [weak self] (response, error) in
            self?.complete(response: response, error: error)
            self?.holder?.remove(connection: self)
            self?.callback {
                self?.onEnd?()
            }
        })

        latestRequest = request
    }

    /// 通信完了時の処理
    private func complete(response: Response?, error: Error?) {
        if isCancelled {
            return
        }

        guard let response = response, error == nil else {
            onNetworkError(error: error)
            return
        }

        var isValidResponse = true
        responseListeners.forEach {
            isValidResponse = isValidResponse && $0.onReceived(response: response)
        }

        guard isValidResponse && self.isValidResponse(response) else {
            onResponseError(response: response)
            return
        }

        handleResponse(response: response)
    }

    open func handleResponse(response: Response) {

        let responseModel: ResponseModel

        do {
            responseModel = try parseResponse(response)
        } catch {
            onParseError(response: response)
            return
        }

        var isValidResponse = true
        responseListeners.forEach {
            isValidResponse = isValidResponse && $0.onReceivedModel(responseModel: responseModel)
        }
        if !isValidResponse {
            onValidationError(response: response, responseModel: responseModel)
            return
        }

        callback {
            self.onSuccess?(responseModel)
            self.responseListeners.forEach {
                $0.afterSuccess(responseModel: responseModel)
            }
            self.listeners.forEach { $0.onEnd(response: response, responseModel: responseModel, error: nil) }
        }
    }

    func onNetworkError(error: Error?) {
        errorListeners.forEach { $0.onNetworkError(error: error) }
        handleError(.network, error: error)
    }

    func onResponseError(response: Response) {
        errorListeners.forEach { $0.onResponseError(response: response) }
        handleError(.invalidResponse, response: response)
    }

    func onParseError(response: Response) {
        errorListeners.forEach { $0.onParseError(response: response) }
        handleError(.parse, response: response)
    }

    func onValidationError(response: Response, responseModel: ResponseModel) {
        errorListeners.forEach { $0.onValidationError(response: response, responseModel: responseModel) }
        handleError(.validation, response: response, responseModel: responseModel)
    }

    /// エラーを処理する
    open func handleError(_ type: ConnectionErrorType,
                          error: Error? = nil,
                          response: Response? = nil,
                          responseModel: ResponseModel? = nil) {

        // TODO メインスレッド制御が必要では？

        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")

        let connectionError = ConnectionError(type: type, nativeError: error)
        onError?(connectionError, response, responseModel)

        errorListeners.forEach {
            $0.afterError(response: response,
                          responseModel: responseModel,
                          error: connectionError)
        }

        listeners.forEach { $0.onEnd(response: response, responseModel: responseModel, error: connectionError) }
    }

    /// 通信を再実行する
    open func restart() {
        connect()
    }

    open func cloneRequest() {
        connect(request: latestRequest)
    }

    /// 通信をキャンセルする
    open func cancel() {
        isCancelled = true
        connector.cancel()
        errorListeners.forEach { $0.onCanceled() }

        // TODO おそらくcancel時にlistenersのonEndが呼ばれない
    }

    open func callback(_ function: @escaping () -> Void) {
        if callbackInMainThread {
            DispatchQueue.main.async {
                function()
            }
        } else {
            function()
        }
    }

    open func makeURL(baseURL: String, query: URLQuery?, encoder: URLEncoder) -> URL? {
        var urlStr = baseURL

        if let query = query {
            let separator = urlStr.contains("?") ? "&" : "?"
            urlStr += separator + query.stringValue(encoder: urlEncoder)
        }

        return URL(string: urlStr)
    }
}

public protocol ConnectionTask: class {
    var requestSpec: RequestSpec { get }

    var listeners: [ConnectionListener] { get }
    var responseListeners: [ConnectionResponseListener] { get }
    var errorListeners: [ConnectionErrorListener] { get }

    var connector: HTTPConnector { get }
    var urlEncoder: URLEncoder { get }
    var isCancelled: Bool { get }
    /// startの引数に渡したコールバックをメインスレッドで呼び出すか
    var callbackInMainThread: Bool { get }

    var latestRequest: Request? { get }

    func cancel()
    func restart()
    func cloneRequest()
}