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

    func parseResponse(response: Response) throws -> ResponseModel

    // TODO ヘッダーやデータ値によってエラー判断されるケースもあるのにステータスコードだけチェックするのは不公平では？
    // バリデーションとパースをまとめてparseResponseに押し付けることもできるし、
    // Validatorを分離する案もある
    func isValidStatusCode(_ code: Int) -> Bool

    // TODO この関数必要か？
    // パースはできたがエラーコードなど含む場合に必要か
    // ResponseListenerでstopして、そこからエラーに流れればよいのでは？
    func isValidResponse(_ model: ResponseModel) -> Bool
}
