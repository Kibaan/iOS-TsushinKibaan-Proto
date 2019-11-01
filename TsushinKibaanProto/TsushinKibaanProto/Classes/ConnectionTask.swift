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

    /// startの引数に渡したコールバックをメインスレッドで呼び出すか
    var callbackInMainThread: Bool { get }

    /// 直近のリクエスト内容
    var latestRequest: Request? { get }

    /// 通信をキャンセルする
    func cancel()

    /// 再リクエストする
    /// リクエスト内容はRequestSpecにより再生成されるため、RequestSpecの実装によっては直前のリクエストと異なるリクエストになる
    /// （例えばリクエストパラメーターに現在時刻を含める場合などは直前のリクエストと異なる）
    func restart()

    /// 直近のリクエストと同じリクエストをする
    func cloneRequest()
}
