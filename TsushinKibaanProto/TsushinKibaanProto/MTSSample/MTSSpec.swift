//
//  MTSSpec.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/08/27.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class MTSSpec<T: MTSResponse>: ConnectionSpec {
    typealias ResponseModel = T

    var url: String {
        return "https://hogehoge"
    }

    var httpMethod: HTTPMethod {
        return .post
    }

    var headers: [String: String] {
        return ["Content-type": "application/x-www-form-urlencoded"]
    }

    var urlQuery: URLQuery? {
        return nil
    }

    init() {}

    func makePostData() -> Data? {
        return nil
    }

    func parseResponse(response: Response) throws -> T {
        fatalError("override this")
    }

    func isValidStatusCode(_ code: Int) -> Bool {
        return code == 200
    }

    func isValidResponse(_ data: T) -> Bool {
        return true
    }
}
