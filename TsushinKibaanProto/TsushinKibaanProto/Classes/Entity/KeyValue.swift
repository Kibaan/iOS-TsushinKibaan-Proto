//
//  KeyValue.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/08/21.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// キーと値のペア。
/// クエリパラメーターを構築するのに用いる。
public struct KeyValue {
    public let key: String
    public let value: String?

    public var stringValue: String {
        if let value = value {
            return "\(key)=\(value)"
        } else {
            return key
        }
    }

    public init(key: String, value: String?) {
        self.key = key
        self.value = value
    }

    public func encodedValue(encoder: URLEncoder) -> String {
        var item = encoder.encode(key)
        if let value = value {
            item += "=\(encoder.encode(value))"
        }
        return item
    }
}
