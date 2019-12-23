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
public protocol ResponseSpec {
    associatedtype ResponseModel

    /// パース前のレスポンスデータのバリデーションを行う
    /// `false` を返すとエラーのコールバックが呼ばれる
    /// 200系以外のHTTPステータスコードを弾いたりするのに使う場合が多い
    ///
    /// - Parameters:
    ///   - response: HTTPのレスポンス情報
    /// - Returns: レスポンスデータが正常の場合 `true`、エラーの場合 `false`
    func isValidResponse(response: Response) -> Bool

    /// HTTPレスポンスをassociated typeに指定した型に変換する
    /// 変換に失敗した場合、何らかのErrorをthrowするとパースエラーとして扱われる
    func parseResponse(response: Response) throws -> ResponseModel

}
