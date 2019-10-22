//
//  HTTPConnector.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTP通信の実行処理
public protocol HTTPConnector {
    /// HTTP通信を行う
    ///
    /// - Parameters:
    ///   - request: URL、HTTPメソッド、ヘッダー、パラメーターなどを含むリクエスト情報
    ///   - complete: 通信完了時に実行されるコールバック。コールバックの引数にはレスポンスの情報と発生したエラーを渡す
    func execute(request: Request, complete: @escaping (Response?, Error?) -> Void)

    /// 実行中の通信をキャンセルする
    func cancel()
}
