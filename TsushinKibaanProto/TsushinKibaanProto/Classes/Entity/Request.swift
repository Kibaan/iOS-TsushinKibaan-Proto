//
//  Request.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/09/12.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTPのリクエスト
public class Request {
    /// リクエストするURL
    public let url: URL
    /// HTTPリクエストメソッド
    public let method: HTTPMethod
    /// HTTPリクエストボディ
    public let body: Data?
    /// HTTPヘッダー
    public let headers: [String: String]

    public init(url: URL, method: HTTPMethod, body: Data?, headers: [String: String]) {
        self.url = url
        self.method = method
        self.body = body
        self.headers = headers
    }
}
