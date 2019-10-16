//
//  ConnectionLifecycle.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信ライフサイクル
open class ConnectionLifecycle<ResponseSpec: ConnectionResponseSpec>: ConnectionTask {
    
    let requestSpec: ConnectionRequestSpec
    let responseSpec: ResponseSpec

    var listeners: [ConnectionListener] = []
    var responseListeners: [ConnectionResponseListener] = []
    var errorListeners: [ConnectionErrorListener] = []

    var connector: HTTPConnector
    var urlEncoder: URLEncoder
    var isCancelled = false

    var indicator: ConnectionIndicator?

    weak var holder = ConnectionHolder.shared

    init(requestSpec: ConnectionRequestSpec,
         responseSpec: ResponseSpec,
         urlEncoder: URLEncoder,
         connector: HTTPConnector) {
        self.requestSpec = requestSpec
        self.responseSpec = responseSpec
        self.urlEncoder = urlEncoder
        self.connector = connector
    }

    func addListener(_ listener: ConnectionListener) {
        listeners.append(listener)
    }

    func addResponseListener(_ listener: ConnectionResponseListener) {
        responseListeners.append(listener)
    }

    func addErrorListener(_ listener: ConnectionErrorListener) {
        errorListeners.append(listener)
    }

    func startConnection() {
        // TODO 実装する
    }
    
    /// 通信処理を開始する
    func connect(onSuccess: ((ResponseSpec.ResponseModel) -> Void)? = nil,
                 onError: ((ResponseSpec.ResponseModel?, ConnectionError) -> Void)? = nil,
                 onEnd: (() -> Void)? = nil) {
        
        guard let url = makeURL(baseURL: requestSpec.url, query: requestSpec.urlQuery, encoder: urlEncoder) else {
            handleError(.invalidURL, onError: onError)
            return
        }
        
        // リクエスト作成
        let request = Request(url: url, method: requestSpec.httpMethod)
        request.body = requestSpec.makePostData()
        request.headers = requestSpec.headers

        listeners.forEach { $0.onStart() }
        indicator?.addReferenceCount()

        // このインスタンスが通信完了まで開放されないよう保持する必要がある
        holder?.add(connection: self)

        print("[\(requestSpec.httpMethod.stringValue)] \(url)")
        // 通信する
        connector.execute(request: request, complete: { [weak self] (response, error) in
            // TODO Should we do this in main thread?
            self?.complete(onSuccess: onSuccess,
                           onError: onError,
                           response: response,
                           error: error)
            DispatchQueue.main.async(execute: {
                self?.listeners.forEach { $0.onEnd() }
            })
            self?.indicator?.removeReferenceCount()
            self?.holder?.remove(connection: self)
            onEnd?()
        })
    }

    /// 通信完了時の処理
    private func complete(onSuccess: ((ResponseSpec.ResponseModel) -> Void)?,
                          onError: ((ResponseSpec.ResponseModel?, ConnectionError) -> Void)?,
                          response: Response?,
                          error: Error?) {
        if isCancelled {
            return
        }

        guard let response = response else {
            handleError(.network, error: error, onError: onError)
            return
        }

        responseListeners.forEach { $0.onReceived(response: response) }

        if error != nil {
            handleError(.network, error: error, response: response, onError: onError)
            return
        }

        // ステータスコードをチェック
        if !responseSpec.isValidStatusCode(response.statusCode) {
            handleError(.statusCode, error: error, response: response, onError: onError)
            return
        }

        handleResponse(onSuccess: onSuccess,
                       onError: onError,
                       response: response)
    }

    open func handleResponse(onSuccess: ((ResponseSpec.ResponseModel) -> Void)?,
                             onError: ((ResponseSpec.ResponseModel?, ConnectionError) -> Void)?,
                             response: Response) {

        let eventChain = EventChain()

        do {
            let responseModel = try responseSpec.parseResponse(response: response)

            responseListeners.forEach {
                $0.onReceivedModel(responseModel: responseModel)
            }

            if responseSpec.isValidResponse(responseModel) {
                // TODO Aspect to be hooked
                onSuccess?(responseModel)
                // TODO Aspect to be hooked
            } else {
                handleError(.invalidResponse, response: response, responseModel: responseModel, onError: onError)
            }
        } catch {
            handleError(.parse, response: response, onError: onError)
        }
    }

    /// エラーを処理する
    open func handleError(_ type: ConnectionErrorType,
                          error: Error? = nil,
                          response: Response? = nil,
                          responseModel: ResponseSpec.ResponseModel? = nil,
                          onError: ((ResponseSpec.ResponseModel?, ConnectionError) -> Void)?) {
        // Override
        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")

        let eventChain = EventChain()


        let errorResponse = ConnectionError(type: type,
                                          response: response,
                                          nativeError: error)
        onError?(responseModel, errorResponse)

        // TODO Aspect to be hooked
    }

    private func callErrorListeners(_ type: ConnectionErrorType,
                                    error: Error? = nil,
                                    response: Response? = nil,
                                    responseModel: ResponseSpec.ResponseModel? = nil) {

        switch type {
        case .invalidURL, .network:
            errorListeners.forEach {
                $0.onNetworkError(error: error)
            }
        case .statusCode:
            errorListeners.forEach {
                $0.onStatusCodeError(response: response)
            }
        case .parse:
            errorListeners.forEach {
                $0.onParseError(response: response)
            }
        case .invalidResponse:
            errorListeners.forEach {
                $0.onValidationError(response: response, dataModel: responseModel)
            }

        default:
        }

    }

    /// 通信を再実行する
    open func restart() {
        startConnection()
    }

    /// 通信をキャンセルする
    open func cancel() {
        isCancelled = true
        connector.cancel()
    }

    ///
    open func after(callback: () -> Void) {
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
    func cancel()
    func restart()
}
