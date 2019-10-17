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
    /// HTTP通信を開始する
    func execute(request: Request, complete: @escaping (Response?, Error?) -> Void)
    /// 実行中の通信をキャンセルする
    func cancel()
}
