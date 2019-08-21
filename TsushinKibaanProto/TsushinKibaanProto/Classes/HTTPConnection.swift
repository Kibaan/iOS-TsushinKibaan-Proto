//
//  HTTPConnection.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class HTTPConnection {
    
    var connector: HTTPConnector
    var listeners: [ConnectionListener] = []
    let spec: ConnectionSpec<Any>
    var urlEncoder: URLEncoder

    init(_ spec: ConnectionSpec<Any>, urlEncoder: URLEncoder = DefaultURLEncoder()) {
        self.spec = spec
        self.urlEncoder = urlEncoder
    }

    func addListener(_ listener: ConnectionListener) {
        listeners.append(listener)
    }
    
    func connect<Response>(success: ((Response) -> Void)? = nil,
                 error: ((HTTPConnectionError) -> Void)? = nil,
                 end: (() -> Void)? = nil) {
        var urlStr = spec.url
        
        if let urlQuery = spec.urlQuery {
            urlStr += "?" + urlQuery.stringValue(encoder: urlEncoder)
        }

        // クエリを作成
        var httpBody: Data?
        if spec.httpMethod == "POST" || spec.httpMethod == "PUT" {
            httpBody = spec.makePostData()
        }
        
        guard let url = URL(string: urlStr) else {
            handleConnectionError(.invalidURL)
            return
        }
        
        // リクエスト作成
        let request = NSMutableURLRequest(url: url)
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpMethod = spec.httpMethod
        request.httpBody = httpBody
        
        // ヘッダー付与
        let headers = spec.headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        listeners.forEach { $0.onStart() }

        // 通信する
        connector.execute(request: request as URLRequest, complete: {  [weak self] (data, resp, err) in
            self?.complete(success: success, data: data, response: resp, error: err)
        })
    }

    /// 通信完了時の処理
    private func complete<Response>(success: ((Response) -> Void)?,
                          data: Data?,
                          response: URLResponse?,
                          error: Error?) {

        defer {
            DispatchQueue.main.async(execute: {
                self.listeners.forEach { $0.onEnd() }
            })
        }

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
            statusCodeError(response: response, data: data)
            return
        }

        handleResponseData(success: success, data: data, response: response)
    }

    open func handleResponseData<Response>(success: ((Response) -> Void)?, data: Data, response: HTTPURLResponse) {

        // データをパース
        let result: Response
        do {
            result = spec.parseResponse(data: data) as? Response
        } catch {
            DispatchQueue.main.async(execute: {
                self.handleError(.parse, result: nil, response: response, data: data)
            })
            return
        }

        if isValidResponse(result) {
            DispatchQueue.main.async(execute: {
                self.handleValidResponse(result: result)
            })
        } else {
            DispatchQueue.main.async(execute: {
                self.handleError(.invalidResponse, result: result, response: response, data: data)
            })
        }
    }

    /// 通信エラーを処理する
    open func handleConnectionError(_ type: HTTPConnectionError, error: Error? = nil, response: HTTPURLResponse? = nil, data: Data? = nil) {
        // Override
        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")
    }
}
