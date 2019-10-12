//
//  DefaultHTTPConnector.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/06.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public class DefaultHTTPConnector: NSObject, HTTPConnector {
    
    var urlSessionTask: URLSessionTask?

    var isRedirectEnabled = true
    // TODO クッキーの制御をする
    var isCookieEnabled = true
    
    public func execute(request: Request, complete: @escaping (Response?, Error?) -> Void) {
        let config = URLSessionConfiguration.default
        config.urlCache = nil // この指定がないとHTTPSでも平文でレスポンスが端末にキャッシュされてしまう
        config.timeoutIntervalForRequest = request.timeoutIntervalShort
        config.timeoutIntervalForResource = request.timeoutInterval
        
        let urlRequest = makeURLRequest(request: request)
        
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        urlSessionTask = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
            let response = self?.makeResponse(urlResponse: urlResponse, data: data)
            complete(response, error)
            self?.urlSessionTask = nil
            // 一部のアプリでは以下の処理を入れないとメモリリークが発生する。
            // 発生しないアプリもあり再現条件は不明だが明示的に破棄しておく
            session.invalidateAndCancel()
        })
        urlSessionTask?.resume()
    }
    
    public func cancel() {
        urlSessionTask?.cancel()
        urlSessionTask = nil
    }
    
    private func makeResponse(urlResponse: URLResponse?, data: Data?) -> Response? {
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            return nil
        }
        
        var hedears: [String: String] = [:]
        for keyValue in urlResponse.allHeaderFields {
            if let key = keyValue.key as? String, let value = keyValue.value as? String {
                hedears[key] = value
            }
        }
        
        return Response(data: data,
                        statusCode: urlResponse.statusCode,
                        headers: hedears,
                        nativeResponse: urlResponse)
    }
    
    private func makeURLRequest(request: Request) -> URLRequest {
        let urlRequest = NSMutableURLRequest(url: request.url)
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.httpMethod = request.method.stringValue
        urlRequest.httpBody = request.body
        
        for (key, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest as URLRequest
    }
}

extension DefaultHTTPConnector: URLSessionTaskDelegate {
    public func urlSession(_ session: URLSession,
                           task: URLSessionTask,
                           willPerformHTTPRedirection response: HTTPURLResponse,
                           newRequest request: URLRequest,
                           completionHandler: @escaping (URLRequest?) -> Void) {
        let newRequest = isRedirectEnabled ? request : nil
        completionHandler(newRequest)
    }
}
