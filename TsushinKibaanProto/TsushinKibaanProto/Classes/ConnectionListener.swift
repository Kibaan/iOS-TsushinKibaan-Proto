//
//  ConnectionListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信の開始と終了の通知を受け取るリスナー
public protocol ConnectionListener: class {
    /// 通信の開始イベント
    func onStart(request: Request)

    /// 通信の終了イベント。通信の成否に関わらず終了時に必ず呼び出される。
    /// 成功やエラーのコールバックが実行された後に呼び出されるため、
    /// Connection.callbackInMainThreadが `true` の場合メインスレッドでの実行、`false` の場合バックグラウンドスレッドでの実行になる。
    /// またキャンセル時はConnection.cancelの呼び出しスレッドでそのまま呼び出される。
    func onEnd(response: Response?, responseModel: Any?, error: ConnectionError?)
}
