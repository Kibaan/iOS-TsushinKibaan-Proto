//
//  RequestSpec.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTPリクエストの仕様
/// URL、HTTPメソッド、ヘッダー、パラメーターなどリクエストの内容を決める
///
/// Specification of a HTTP request.
/// This specify contents of a request including url, HTTP method, headers and parameters.
///
public protocol RequestSpec {
    /// リクエスト先のURL
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
