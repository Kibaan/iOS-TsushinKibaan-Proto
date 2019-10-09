//
//  ConnectionResponseSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public protocol ConnectionResponseSpec {
    associatedtype Response
    
    func isValidStatusCode(_ code: Int) -> Bool
    func parseResponse(data: Data, statusCode: Int) throws -> Response
    func isValidResponse(_ data: Response) -> Bool
}
