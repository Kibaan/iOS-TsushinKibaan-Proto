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
    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var urlQuery: URLQuery? { get }
    
    func makePostData() -> Data?
}
