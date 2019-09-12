//
//  HTTPConnection.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class Connection<Spec: ConnectionSpec>: Cancellable {
    
    let spec: Spec
    var listeners: [ConnectionListener] = []
    var events: [ConnectionEvent] = []
    var connector: HTTPConnector
    var urlEncoder: URLEncoder
    weak var holder = ConnectionHolder.shared
    var isCancelled = false

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
            handleError(.invalidURL)
            return
        }
        
        // リクエスト作成
        let request = Request(url: url, method: spec.httpMethod)
        request.body = httpBody
        request.headers = spec.headers

        listeners.forEach { $0.onStart() }

        // このインスタンスが通信完了まで開放されないよう保持する必要がある
        holder?.add(connection: self)

        // 通信する
        connector.execute(request: request, complete: { [weak self] (data, resp, err) in
            // TODO メインスレッドでやらなくていい？
            self?.complete(success: success, data: data, response: resp, error: err)
            DispatchQueue.main.async(execute: {
                self?.listeners.forEach { $0.onEnd() }
            })
            self?.holder?.remove(connection: self)
        })
    }

    /// 通信完了時の処理
    private func complete(success: ((Spec.Response) -> Void)?,
                          data: Data?,
                          response: URLResponse?,
                          error: Error?) {
        if isCancelled {
            return
        }

        guard let response = response as? HTTPURLResponse else {
            handleError(.network, error: error)
            return
        }

        // 通信エラーをチェック
        if error != nil {
            handleError(.network, error: error, response: response)
            return
        }

        guard let data = data else {
            handleError(.network, error: error, response: response)
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

    /// エラーを処理する
    open func handleError(_ type: ConnectionError, error: Error? = nil, response: HTTPURLResponse? = nil, data: Data? = nil) {
        // Override
        let message = error?.localizedDescription ?? ""
        print("[ConnectionError] Type= \(type.description), NativeMessage=\(message)")
    }
    
    open func cancel() {
        isCancelled = true
        // TODO キャンセルする
    }
}

public protocol Cancellable: class {
    func cancel()
}
