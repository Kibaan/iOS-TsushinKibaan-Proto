//
//  HTTPMethod.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/23.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTPメソッド
public enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
    case head
    case options
    case trace
    case connect

    /// HTTPメソッドの大文字文字列（`GET`など）
    var stringValue: String {
        return rawValue.uppercased()
    }
}
