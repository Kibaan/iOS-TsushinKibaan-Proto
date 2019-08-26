//
//  HTTPConnection.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class Connection<Spec: ConnectionSpec> {
    
    let spec: Spec
    var listeners: [ConnectionListener] = []
    var events: [ConnectionEvent] = []
    var connector: HTTPConnector
    var urlEncoder: URLEncoder

    init(spec: Spec, urlEncoder: URLEncoder = DefaultURLEncoder(), connector: HTTPConnector) {
        self.spec = spec
        self.urlEncoder = urlEncoder
        self.connector = connector
    }

    func addListener(_ listener: ConnectionListener) {
        listeners.append(listener)
    }
    
    func connect(success: ((Spec.Response) -> Void)? = nil,
                 error: ((ConnectionError) -> Void)? = nil,
                 end: (() -> Void)? = nil) {
        var urlStr = spec.url
        
        if let urlQuery = spec.urlQuery {
            urlStr += "?" + urlQuery.stringValue(encoder: urlEncoder)
        }

        // クエリを作成
        var httpBody: Data?
        if spec.httpMethod == .post || spec.httpMethod == .put {
            httpBody = spec.makePostData()
        }
        
        guard let url = URL(string: urlStr) else {
            handleConnectionError(.invalidURL)
            return
        }
        
        // リクエスト作成
        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = spec.httpMethod.stringValue
        request.httpBody = httpBody
        
        // ヘッダー付与
        let headers = spec.headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        listeners.forEach { $0.onStart() }

        // 通信する
        connector.execute(request: request as URLRequest, complete: { [weak self] (data, resp, err) in
            // TODO weakにするとConnectionをローカル変数にしたとき開放されてしまうかもしれない
            self?.complete(success: success, data: data, response: resp, error: err)
            DispatchQueue.main.async(execute: {
                self?.listeners.forEach { $0.onEnd() }
            })
        })
    }

    /// 通信完了時の処理
    private func complete(success: ((Spec.Response) -> Void)?,
                          data: Data?,
                          response: URLResponse?,
                          error: Error?) {
        // TODO キャンセル済みの場合
        if connector.isCancelled {
            return
        }

        guard let response = response as? HTTPURLResponse else {
            handleConnectionError(.network, error: error)
            return
        }

        // 通信エラーをチェック
        if error != nil {
            handleConnectionError(.network, error: error, response: response)
            return
        }

        guard let data = data else {
            handleConnectionError(.network, error: error, response: response)
            return
        }

        // ステータスコードをチェック
        if !spec.isValidStatusCode(response.statusCode) {
// TODO            statusCodeError(response: response, data: data)
            return
        }

        handleResponseData(success: success, data: data, response: response)
    }

    open func handleResponseData(success: ((Spec.Response) -> Void)?, data: Data, response: HTTPURLResponse) {

        do {
            let response = try spec.parseResponse(data: data, statusCode: response.statusCode)

            if spec.isValidResponse(response) {
//            handleValidResponse(result: result)
                success?(response)
            } else {
//            handleError(.invalidResponse, result: result, response: response, data: data)
            }
        } catch {
//            handleError(.parse, result: nil, response: response, data: data)
//            return
        }
    }

    /// 通信エラーを処理する
    open func handleConnectionError(_ type: ConnectionError, error: Error? = nil, response: HTTPURLResponse? = nil, data: Data? = nil) {
        // Override
        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")
    }
}

class Connection2<Response> {

    init<T: ConnectionSpec>(spec: T) where T.Response == Response {
    }

    func test(callback: (Response) -> Void) {
        
    }
}
