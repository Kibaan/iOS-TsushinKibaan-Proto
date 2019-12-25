//
//  Response.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/09/18.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTPレスポンスの情報
/// レスポンスボディの他、ステータスコード、ヘッダーの情報を持つ
public struct Response {
    /// レスポンスデータ
    let data: Data
    /// HTTPステータスコード
    let statusCode: Int
    /// レスポンスヘッダー
    let headers: [String: String]
    /// ネイティブSDKのレスポンスオブジェクト。
    /// iOSの場合、URLResponseが入る。
    let nativeResponse: Any?
}
