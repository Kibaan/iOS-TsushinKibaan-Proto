//
//  SimpleSpec.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/09/06.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class SimpleSpec: ConnectionSpec {
    typealias Response = String

    var url: String { return "https://hogehoge" }
    var httpMethod: HTTPMethod { return .get }
    var headers: [String: String] { return [:] }
    var urlQuery: URLQuery? { return nil }

    func makePostData() -> Data? { return nil }
    func isValidStatusCode(_ code: Int) -> Bool { return true }
    func isValidResponse(_ data: Response) -> Bool { return true }

    func parseResponse(data: Data, statusCode: Int) throws -> Response {

        if let string = String(bytes: data, encoding: .utf8) {
            return string
        }

        throw ConnectionError.parse
    }
}
