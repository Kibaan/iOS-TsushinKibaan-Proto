//
//  ConnectionTask.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/11/01.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 一連の通信処理の制御
public protocol ConnectionTask: class {
    /// HTTPリクエストの仕様
    var requestSpec: RequestSpec { get }

    /// 通信開始、終了のリスナー
    var listeners: [ConnectionListener] { get }
    /// 通信レスポンスのリスナー
    var responseListeners: [ConnectionResponseListener] { get }
    /// 通信エラー、キャンセルのリスナー
    var errorListeners: [ConnectionErrorListener] { get }

    /// HTTP通信の実行処理
    var connector: HTTPConnector { get }

    /// クエリパラメーターのURLエンコード処理
    var urlEncoder: URLEncoder { get }

    /// キャンセルされたか
    var isCancelled: Bool { get }

    /// コールバックをメインスレッドで呼び出すか
    var callbackInMainThread: Bool { get }

    /// 直近のリクエスト内容
    var latestRequest: Request? { get }

    /// 通信を開始する
    ///
    func start()

    /// 通信をキャンセルする
    ///
    func cancel()

    /// 通信を再実行する
    ///
    /// - Parameters:
    ///   - cloneRequest: 直前のリクエストと全く同じリクエストをする場合は `true`。リクエスト内容を再構築する場合 `false` を指定する。
    ///     例えばリクエストパラメーターに現在時刻を動的に含める場合、`true` では前回リクエストと同時刻になるが、 `false` では新しい時刻が設定される。
    ///   - shouldNotify: 通信開始のコールバックを呼ぶ場合は `true`。
    ///     リスナーに通知せずこっそり再通信したい場合などに `false` を指定する。
    func restart(cloneRequest: Bool, shouldNotify: Bool)

}
