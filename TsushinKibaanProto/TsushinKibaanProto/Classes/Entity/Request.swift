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
    public var timeoutIntervalShort: TimeInterval = 30.0
    public var timeoutInterval: TimeInterval = 60.0
    public let url: URL
    public let method: HTTPMethod
    public var body: Data?
    public var headers: [String: String] = [:]

    public init(url: URL, method: HTTPMethod) {
        self.url = url
        self.method = method
    }
}
