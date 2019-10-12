//
//  SimpleSpec.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/09/06.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 最小構成のConnectionSpec実装
/// GoogleトップページをGETでリクエストして、取得データをStringで返す
class SimpleSpec: ConnectionSpec {
    typealias ResponseModel = String

    var url: String { return "https://www.google.com/" }
    var httpMethod: HTTPMethod { return .get }
    var headers: [String: String] { return [:] }
    var urlQuery: URLQuery? { return nil }

    func makePostData() -> Data? { return nil }
    func isValidStatusCode(_ code: Int) -> Bool { return true }
    func isValidResponse(_ model: ResponseModel) -> Bool { return true }

    func parseResponse(response: Response) throws -> ResponseModel {
        if let string = String(bytes: response.data, encoding: .utf8) {
            return string
        }
        throw ConnectionErrorType.parse
    }
}
