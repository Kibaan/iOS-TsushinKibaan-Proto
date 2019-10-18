//
//  ConnectionError.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/21.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTP通信のエラー種別
public enum ConnectionErrorType: Error {
    /// 不正なURL
    case invalidURL
    /// オフライン、タイムアウトなどのネットワークエラー
    case network
    /// HTTPステータスコードが既定ではない
    case statusCode
    /// レスポンスのパースに失敗
    case parse
    /// バリデーションエラー
    case validation

    public var description: String {
        switch self {
        case .invalidURL:
            return "リクエスト先のURLが不正です。"
        case .network:
            return "通信エラーが発生しました。 通信環境が不安定か、接続先が誤っている可能性があります。"
        case .statusCode:
            return "HTTPステータスコードが不正です。"
        case .parse:
            return "レスポンスデータのパースに失敗しました。"
        case .validation:
            return "レスポンスデータの内容が不正です。"
        }
    }
}
