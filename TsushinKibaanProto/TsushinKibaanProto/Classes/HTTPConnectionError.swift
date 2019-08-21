//
//  HTTPConnectionError.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/08/21.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// HTTP通信のエラー種別
public enum HTTPConnectionError {
    // URL不正
    case invalidURL
    // オフライン、タイムアウトなどの通信エラー
    case network
    // HTTPステータスコードが既定ではないエラー
    case statusCode
    // レスポンスのパースに失敗
    case parse
    // レスポンスは取得できたが内容がエラー
    case invalidResponse

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
        case .invalidResponse:
            return "レスポンスデータのバリデーションエラーです。"
        }
    }
}
