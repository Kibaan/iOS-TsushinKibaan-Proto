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

    public var connector: HTTPConnector = DefaultImplementation.shared.httpConnector()
    public var urlEncoder: URLEncoder = DefaultImplementation.shared.urlEncoder()

    /// キャンセルされたかどうか。このフラグが `true` だと通信終了してもコールバックが呼ばれない
    /// Cancel後の再通信は想定しない
    public private(set) var isCancelled = false

    /// コールバックをメインスレッドで呼び出すか
    public var callbackInMainThread = true

    var onSuccess: ((ResponseModel) -> Void)?
    var onError: ((ConnectionError, Response?, ResponseModel?) -> Void)?

    /// 終了コールバック
    /// (response: Response?, responseModel: Any?, error: ConnectionError?) -> Void
    var onEnd: ((Response?, Any?, ConnectionError?) -> Void)?

    public private(set) var latestRequest: Request?

    public weak var holder = ConnectionHolder.shared

    init<T: ResponseSpec>(requestSpec: RequestSpec,
                          responseSpec: T,
                          onSuccess: ((ResponseModel) -> Void)? = nil) where T.ResponseModel == ResponseModel {
        self.requestSpec = requestSpec
        self.parseResponse = responseSpec.parseResponse
        self.isValidResponse = responseSpec.isValidResponse
        self.onSuccess = onSuccess
    }

    init<T: ConnectionSpec>(_ connectionSpec: T,
                            onSuccess: ((ResponseModel) -> Void)? = nil) where T.ResponseModel == ResponseModel {
        self.requestSpec = connectionSpec
        self.parseResponse = connectionSpec.parseResponse
        self.isValidResponse = connectionSpec.isValidResponse
        self.onSuccess = onSuccess
    }

    func addListener(_ listener: ConnectionListener) { listeners.append(listener) }
    func addResponseListener(_ listener: ConnectionResponseListener) { responseListeners.append(listener) }
    func addErrorListener(_ listener: ConnectionErrorListener) { errorListeners.append(listener) }

    func removeListener(_ listener: ConnectionListener) { listeners.removeAll { $0 === listener } }
    func removeResponseListener(_ listener: ConnectionResponseListener) { responseListeners.removeAll { $0 === listener } }
    func removeErrorListener(_ listener: ConnectionErrorListener) { errorListeners.removeAll { $0 === listener } }

    @discardableResult
    func setOnError(onError: @escaping (ConnectionError, Response?, ResponseModel?) -> Void) -> Self {
        self.onError = onError
        return self
    }

    @discardableResult
    func setOnEnd(onEnd: @escaping (Response?, Any?, ConnectionError?) -> Void) -> Self {
        self.onEnd = onEnd
        return self
    }

    /// 処理を開始する
    public func start() {
        connect()
    }
    
    /// 通信処理を開始する
    ///
    /// - Parameters:
    ///   - shouldNotify: 通信開始のコールバックを呼び出す場合は `true`。リスナーに通知せず再通信したい場合に `false` を指定する。
    ///
    private func connect(request: Request? = nil, shouldNotify: Bool = true) {
        guard let url = makeURL(baseURL: requestSpec.url, query: requestSpec.urlQuery, encoder: urlEncoder) else {
            handleError(.invalidURL)
            return
        }

        // リクエスト作成
        let request = request ?? Request(url: url,
                                         method: requestSpec.httpMethod,
                                         body: requestSpec.makePostData(),
                                         headers: requestSpec.headers)

        if shouldNotify {
            listeners.forEach {
                $0.onStart(connection: self, request: request)
            }
        }

        // このインスタンスが通信完了まで開放されないよう保持する必要がある
        holder?.add(connection: self)

        print("[\(requestSpec.httpMethod.stringValue)] \(url)")

        // 通信する
        connector.execute(request: request, complete: { [weak self] (response, error) in
            self?.complete(response: response, error: error)
            self?.holder?.remove(connection: self)
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
            isValidResponse = isValidResponse && $0.onReceived(connection: self, response: response)
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
            isValidResponse = isValidResponse && $0.onReceivedModel(connection: self, responseModel: responseModel)
        }
        if !isValidResponse {
            onValidationError(response: response, responseModel: responseModel)
            return
        }

        callback {
            self.onSuccess?(responseModel)
            self.responseListeners.forEach {
                $0.afterSuccess(connection: self, responseModel: responseModel)
            }
            self.end(response: response, responseModel: responseModel, error: nil)
        }
    }

    func onNetworkError(error: Error?) {
        controlError(callListener: {
            return $0.onNetworkError(connection: self, error: error)
        }, callError: {
            self.handleError(.network, error: error)
        })
    }

    func onResponseError(response: Response) {
        controlError(callListener: {
            return $0.onResponseError(connection: self, response: response)
        }, callError: {
            self.handleError(.invalidResponse, response: response)
        })
    }

    func onParseError(response: Response) {
        controlError(callListener: {
            return $0.onParseError(connection: self, response: response)
        }, callError: {
            self.handleError(.parse, response: response)
        })
    }

    func onValidationError(response: Response, responseModel: ResponseModel) {
        controlError(callListener: {
            return $0.onValidationError(connection: self, response: response, responseModel: responseModel)
        }, callError: {
            self.handleError(.validation, response: response, responseModel: responseModel)
        })
    }

    /// エラーを処理する
    private func controlError(callListener: (ConnectionErrorListener) -> EventChain, callError: @escaping () -> Void) {
        var stopNext = false

        for i in errorListeners.indices {
            let result = callListener(errorListeners[i])
            if result == .stopImmediately {
                return
            }
            if result == .stop {
                stopNext = true
            }
        }

        if stopNext {
            return
        }

        callback {
            callError()
        }
    }

    /// エラーを処理する
    open func handleError(_ type: ConnectionErrorType,
                          error: Error? = nil,
                          response: Response? = nil,
                          responseModel: ResponseModel? = nil) {

        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")

        let connectionError = ConnectionError(type: type, nativeError: error)
        onError?(connectionError, response, responseModel)

        errorListeners.forEach {
            $0.afterError(connection: self,
                          response: response,
                          responseModel: responseModel,
                          error: connectionError)
        }

        end(response: response, responseModel: responseModel, error: connectionError)
    }

    /// 通信を再実行する
    open func restart(cloneRequest: Bool, shouldNotify: Bool) {
        let request = cloneRequest ? latestRequest : nil
        connect(request: request, shouldNotify: shouldNotify)
    }

    /// 通信をキャンセルする
    open func cancel() {
        // TODO 既に通信コールバックが走っている場合何もしない。通信コールバック内でキャンセルした場合に、onEndが二重で呼ばれないようにする必要がある
        isCancelled = true
        connector.cancel()

        errorListeners.forEach { $0.onCanceled(connection: self) }
        let error = ConnectionError(type: .canceled, nativeError: nil)
        end(response: nil, responseModel: nil, error: error)
    }

    private func end(response: Response?, responseModel: Any?, error: ConnectionError?) {
        listeners.forEach { $0.onEnd(connection: self, response: response, responseModel: responseModel, error: error) }
        onEnd?(response, responseModel, error)
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

public struct DefaultImplementation {

    public static var shared = DefaultImplementation()

    public var urlEncoder: () -> URLEncoder = {
        return DefaultURLEncoder()
    }

    public var httpConnector: () -> HTTPConnector = {
        return DefaultHTTPConnector()
    }
}
