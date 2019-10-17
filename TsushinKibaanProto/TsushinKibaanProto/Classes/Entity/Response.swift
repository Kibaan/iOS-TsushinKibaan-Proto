//
//  Response.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/09/18.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

public struct Response {
    let data: Data
    let statusCode: Int
    let headers: [String: String]
    let nativeResponse: Any?
}
