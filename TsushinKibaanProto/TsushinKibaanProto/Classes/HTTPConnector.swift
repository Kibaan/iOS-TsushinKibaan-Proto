//
//  HTTPConnector.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// HTTP通信の実行処理
protocol HTTPConnector {
    var isCancelled: Bool { get }
    func execute(request: Request, complete: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel()
}

public class DefaultHTTPConnector: HTTPConnector {

    var isCancelled: Bool = false

    var urlSessionTask: URLSessionTask?

    func execute(request: Request, complete: @escaping (Data?, URLResponse?, Error?) -> Void) {
        isCancelled = false

        let config = URLSessionConfiguration.default
        config.urlCache = nil // この指定がないとHTTPSでも平文でレスポンスが端末にキャッシュされてしまう
        config.timeoutIntervalForRequest = request.timeoutIntervalShort
        config.timeoutIntervalForResource = request.timeoutInterval

        let urlRequest = toURLRequest(request: request)

        let session = URLSession(configuration: config)
        urlSessionTask = session.dataTask(with: urlRequest, completionHandler: { [weak self] (data, resp, err) in
            complete(data, resp, err)
            self?.urlSessionTask = nil
            // 一部のアプリでは以下の処理を入れないとメモリリークが発生する。
            // 発生しないアプリもあり再現条件は不明だが明示的に破棄しておく
            session.invalidateAndCancel()
        })
        urlSessionTask?.resume()
    }

    func cancel() {
        urlSessionTask?.cancel()
        urlSessionTask = nil
        isCancelled = true
    }

    private func toURLRequest(request: Request) -> URLRequest {
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
