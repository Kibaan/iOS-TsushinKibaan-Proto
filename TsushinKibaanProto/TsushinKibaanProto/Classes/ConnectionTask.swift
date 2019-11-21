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

    /// 通信を開始する
    ///
    /// - Parameters:
    ///   - callback: 通信開始時のコールバック※を呼び出す場合は true。
    /// ※ ConnectionListener.onStart
    func start(callback: Bool)

    /// 通信をキャンセルする
    ///
    /// - Parameters:
    ///   - callback: キャンセル時のコールバック※を呼び出す場合は true。
    /// ※ ConnectionListener.onEnd、ConnectionErrorListener.onCancel など
    // TODO callback 引数は本当にいるか？ 通信エラー時のリトライはキャンセルでなく「まだ終わってない」なのでは？
    func cancel(callback: Bool)

    /// 通信を再実行する
    ///
    /// - Parameters:
    ///   - cloneRequest: 直前のリクエストと全く同じリクエストをする場合は true。
    ///   falseの場合リクエスト内容はRequestSpecにより再生成されるため、RequestSpecの実装によっては直前のリクエストと異なるリクエストになる。
    /// （例えばリクエストパラメーターに現在時刻を含める場合、再生成すると直前のリクエスト内容が変化する）
    ///   - startCallback: 通信開始のコールバックを呼ぶ場合は true。
    func restart(cloneRequest: Bool, startCallback: Bool)

}
