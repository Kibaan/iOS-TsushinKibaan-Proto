//
//  ConnectionListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信の開始と終了の通知を受け取るリスナー
/// バックグラウンドスレッドから呼び出されるため、UIの操作を行う場合はメインスレッドに切り替える必要がある
public protocol ConnectionListener {
    /// 通信の開始イベント
    func onStart(request: Request)

    /// 通信の終了イベント。通信の成否に関わらず終了時に必ず呼び出される。
    /// 他のコールバックが全て実行された後に呼び出されるため、
    /// Connection.callbackInMainThreadがtrueの場合メインスレッドでの実行、falseの場合バックグラウンドスレッドでの実行になる。
    func onEnd(response: Response?, responseModel: Any?, error: ConnectionError?)
}
