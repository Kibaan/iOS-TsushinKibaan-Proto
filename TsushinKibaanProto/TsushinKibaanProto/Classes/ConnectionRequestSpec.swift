//
//  ConnectionRequestSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信リクエストの仕様
public protocol ConnectionRequestSpec {
    /// リクエスト先URL
    var url: String { get }
    /// HTTPメソッド
    var httpMethod: HTTPMethod { get }
    /// リクエストヘッダー
    var headers: [String: String] { get }
    /// URLに付与するクエリパラメーター
    var urlQuery: URLQuery? { get }

    /// POSTデータを作成する
    func makePostData() -> Data?
}
