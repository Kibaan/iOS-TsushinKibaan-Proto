//
//  ResponseSpec.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTPレスポンスの仕様
/// HTTPレスポンスをassociated typeに指定された型に変換する
/// また、HTTPステータスコードを見てエラーかどうかを判定する
///
///
///
public protocol ResponseSpec {
    associatedtype ResponseModel

    /// HTTPレスポンスをassociated typeに指定された型に変換する
    /// 変換に失敗した場合、何らかのErrorをthrowするとパースエラーとして扱われる
    func parseResponse(response: Response) throws -> ResponseModel

    // TODO ヘッダーやデータ値によってエラー判断されるケースもあるのにステータスコードだけチェックするのは不公平では？
    // バリデーションとパースをまとめてparseResponseに押し付けることもできるし、Validatorを分離する案もある
    func isValidStatusCode(code: Int) -> Bool

}
