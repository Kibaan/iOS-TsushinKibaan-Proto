//
//  URLQuery.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/21.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// key=valueの&つなぎ形式のクエリ
/// URLのクエリパラメーターを構築するのに用いる
public class URLQuery: ExpressibleByDictionaryLiteral {

    public var keyValues: [KeyValue] = []

    public init() {}

    public init(string: String?) {
        guard let string = string?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        keyValues = string
            .components(separatedBy: "&")
            .filter { 0 < $0.count }
            .map {
                let pairs = $0.components(separatedBy: "=")
                let key = pairs[0].removingPercentEncoding ?? ""
                let value = 1 < pairs.count ? pairs[1].removingPercentEncoding : nil
                return KeyValue(key: key, value: value)
            }
    }

    public required init(dictionaryLiteral elements: (String, String?)...) {
        keyValues = elements.map { KeyValue(key: $0.0, value: $0.1) }
    }

    public init(keyValues: [KeyValue]) {
        self.keyValues = keyValues
    }

    public subscript (key: String) -> String? {
        get {
            return keyValues.first { $0.key == key }?.value
        }
        set(value) {
            let keyValue = KeyValue(key: key, value: value)
            let offset = keyValues.enumerated().first { $0.element.key == key }?.offset

            if let offset = offset {
                keyValues[offset] = keyValue
            } else {
                keyValues.append(keyValue)
            }
        }
    }

    public func stringValue(encoder: URLEncoder) -> String {
        return keyValues
            .map { $0.encodedValue(encoder: encoder) }
            .joined(separator: "&")
    }
}
