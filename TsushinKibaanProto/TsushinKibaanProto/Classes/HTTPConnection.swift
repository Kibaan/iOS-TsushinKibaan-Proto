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
    
    init(_ spec: ConnectionSpec<Any>) {
        self.spec = spec
    }

    func addListener(_ listener: ConnectionListener) {
        listeners.append(listener)
    }
    
    func connect<Response>(success: ((Response) -> Void)? = nil,
                 error: (() -> Void)? = nil,
                 end: (() -> Void)? = nil) {
        var urlStr = spec.url
        
        prepareRequest()
        
        // クエリを作成
        var httpBody: Data?
        if spec.httpMethod == "POST" || spec.httpMethod == "PUT" {
            httpBody = spec.makePostData()
        } else if let query = spec.makeQueryString() {
            urlStr += "?" + query
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
        if let userAgent = HTTPConnection.defaultUserAgent, !headers.keys.map({ $0.lowercased() }).contains("user-agent") {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // 通信する
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        connector.timeoutIntervalForRequest = timeoutIntervalForRequest
        connector.timeoutIntervalForResource = timeoutIntervalForResource
        connector.execute(request: request as URLRequest, completionHandler: {  [weak self] (data, resp, err) in
            self?.complete(data: data, response: resp, error: err)
        })
        
//        ConnectionHolder.add(self)
//        updateIndicator(referenceCount: 1)
    }
}
