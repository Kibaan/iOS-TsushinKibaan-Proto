//
//  Response.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/09/18.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public struct Response {
    let data: Data
    let statusCode: Int
    let headers: [String: String]
    let nativeResponse: Any?
}
