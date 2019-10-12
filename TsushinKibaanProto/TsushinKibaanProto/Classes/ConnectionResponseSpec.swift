//
//  ConnectionResponseSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信レスポンスの仕様
public protocol ConnectionResponseSpec {
    associatedtype ResponseModel
    
    func isValidStatusCode(_ code: Int) -> Bool
    func parseResponse(response: Response) throws -> ResponseModel

    // TODO この関数必要か？
    // パースはできたがエラーコードなど含む場合
    func isValidResponse(_ model: ResponseModel) -> Bool
}
