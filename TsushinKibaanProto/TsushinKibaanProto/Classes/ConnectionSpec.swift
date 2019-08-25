//
//  ConnectionSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

protocol ConnectionSpec {
    associatedtype Response

    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var urlQuery: URLQuery? { get }
    
    func makePostData() -> Data?
    
    func isValidStatusCode(_ code: Int) -> Bool
    
    func parseResponse(data: Data, statusCode: Int) throws -> Response
    
    func isValidResponse(_ data: Response) -> Bool
}
