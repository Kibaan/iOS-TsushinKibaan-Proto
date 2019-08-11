//
//  ConnectionSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class ConnectionSpec<Response> {
    
    var url: String { return "" }
    var httpMethod: String { return "GET" }
    var headers: [String: String] { return [:] }
    
    func makePostData() -> Data? {
        return nil
    }
    
    func isValidStatusCode(_ code: Int) -> Bool {
        return code == 200
    }
    
    func parseResponse(data: Data) -> Response? {
        return nil
    }
    
    func isValidResponse(_ data: Response) -> Bool {
        return true
    }
}
