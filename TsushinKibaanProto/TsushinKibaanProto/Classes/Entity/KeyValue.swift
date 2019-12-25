//
//  KeyValue.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/21.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// キーと値のペア
/// クエリパラメーターを構築するのに用いる
public struct KeyValue {
    
    public let key: String
    public let value: String?

    /// "キー=値" 形式の文字列。値が `nil` の場合はキーのみになり=がつかない。
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

    /// キーと値をURLEncodeして、キー=値の文字列にする
    public func encodedValue(encoder: URLEncoder) -> String {
        var item = encoder.encode(key)
        if let value = value {
            item += "=\(encoder.encode(value))"
        }
        return item
    }
}
