//
//  HTTPConnector.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

protocol HTTPConnector {
    var isCancelled: Bool { get }
    func execute(request: Request, complete: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel()
}

//class DefaultHTTPConnector: HTTPConnector {
//
//    open func execute(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
//        isCancelled = false
//        let config = URLSessionConfiguration.default
//        config.urlCache = nil
//        config.timeoutIntervalForRequest = timeoutIntervalForRequest
//        config.timeoutIntervalForResource = timeoutIntervalForResource
// request.cachePolicy = .reloadIgnoringCacheData
// ヘッダー付与
//let headers = spec.headers
//for (key, value) in headers {
//    request.setValue(value, forHTTPHeaderField: key)
//}
//        let session = URLSession(configuration: config)
//        urlSessionTask = session.dataTask(with: request, completionHandler: { [weak self] (data, resp, err) in
//            completionHandler(data, resp, err)
//            self?.urlSessionTask = nil
//            // 一部のアプリでは以下の処理を入れないとメモリリークが発生する。
//            // 発生しないアプリもあり再現条件は不明だが明示的に破棄しておく
//            session.invalidateAndCancel()
//        })
//        urlSessionTask?.resume()
//    }
//
//    open func cancel() {
//        urlSessionTask?.cancel()
//        urlSessionTask = nil
//        isCancelled = true
//    }
//}
