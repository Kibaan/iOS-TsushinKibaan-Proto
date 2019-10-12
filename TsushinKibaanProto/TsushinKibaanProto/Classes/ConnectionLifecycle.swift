//
//  ConnectionLifecycle.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信ライフサイクル
open class ConnectionLifecycle<Spec: ConnectionSpec>: ConnectionTask {
    
    let spec: Spec
    var listeners: [ConnectionListener] = []
    var events: [ConnectionEvent] = []
    
    var connector: HTTPConnector
    var urlEncoder: URLEncoder
    var isCancelled = false

    weak var holder = ConnectionHolder.shared

    init(spec: Spec, urlEncoder: URLEncoder = DefaultURLEncoder(), connector: HTTPConnector) {
        self.spec = spec
        self.urlEncoder = urlEncoder
        self.connector = connector
    }

    func addListener(_ listener: ConnectionListener) {
        listeners.append(listener)
    }
    
    func startConnection() {
        // TODO 実装する
    }
    
    /// 通信処理を開始する
    func connect(onSuccess: ((Spec.ResponseModel) -> Void)? = nil,
                 onError: ((Spec.ResponseModel?, ConnectionError) -> Void)? = nil,
                 onEnd: (() -> Void)? = nil) {
        
        guard let url = makeURL(baseURL: spec.url, query: spec.urlQuery, encoder: urlEncoder) else {
            handleError(.invalidURL, onError: onError)
            return
        }
        
        // リクエスト作成
        let request = Request(url: url, method: spec.httpMethod)
        request.body = spec.makePostData()
        request.headers = spec.headers

        listeners.forEach { $0.onStart() }

        // このインスタンスが通信完了まで開放されないよう保持する必要がある
        holder?.add(connection: self)

        print("[\(spec.httpMethod.stringValue)] \(url)")
        // 通信する
        connector.execute(request: request, complete: { [weak self] (response, error) in
            // TODO メインスレッドでやらなくていいのか？
            self?.complete(onSuccess: onSuccess,
                           onError: onError,
                           response: response,
                           error: error)
            DispatchQueue.main.async(execute: {
                self?.listeners.forEach { $0.onEnd() }
            })
            self?.holder?.remove(connection: self)
            onEnd?()
        })
    }
    
    open func makeURL(baseURL: String, query: URLQuery?, encoder: URLEncoder) -> URL? {
        var urlStr = baseURL
        
        if let query = query {
            let separator = urlStr.contains("?") ? "&" : "?"
            urlStr += separator + query.stringValue(encoder: urlEncoder)
        }
        
        return URL(string: urlStr)
    }

    /// 通信完了時の処理
    private func complete(onSuccess: ((Spec.ResponseModel) -> Void)?,
                          onError: ((Spec.ResponseModel?, ConnectionError) -> Void)?,
                          response: Response?,
                          error: Error?) {
        if isCancelled {
            return
        }

        guard let response = response else {
            handleError(.network, error: error, onError: onError)
            return
        }

        if error != nil {
            handleError(.network, error: error, response: response, onError: onError)
            return
        }

        guard let data = response.data else {
            handleError(.network, error: error, response: response, onError: onError)
            return
        }

        // ステータスコードをチェック
        if !spec.isValidStatusCode(response.statusCode) {
            handleError(.statusCode, error: error, response: response, onError: onError)
            return
        }

        handleResponseData(onSuccess: onSuccess,
                           onError: onError,
                           data: data,
                           response: response)
    }

    open func handleResponseData(onSuccess: ((Spec.ResponseModel) -> Void)?,
                                 onError: ((Spec.ResponseModel?, ConnectionError) -> Void)?,
                                 data: Data,
                                 response: Response) {

        let eventChain = EventChain()
        events.forEach {
            $0.beforeParse(connection: self, data: data, statusCode: response.statusCode, chain: eventChain)
        }

        do {
            let responseModel = try spec.parseResponse(response: response)

            events.forEach {
                $0.afterParse(connection: self, response: responseModel)
            }

            if spec.isValidResponse(responseModel) {
                events.forEach {
                    $0.beforSuccessCallback(connection: self, response: responseModel, chain: eventChain)
                }
                onSuccess?(responseModel)
                events.forEach {
                    $0.afterSuccessCallback(connection: self)
                }
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
                          responseModel: Spec.ResponseModel? = nil,
                          onError: ((Spec.ResponseModel?, ConnectionError) -> Void)?) {
        // Override
        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")

        let eventChain = EventChain()
        events.forEach {
            $0.beforErrorCallback(connection: self, chain: eventChain)
        }
        
        let errorResponse = ConnectionError(type: type,
                                          response: response,
                                          nativeError: error)
        onError?(responseModel, errorResponse)

        events.forEach {
            $0.afterErrorCallback(connection: self)
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
}

public protocol ConnectionTask: class {
    func cancel()
    func restart()
}
