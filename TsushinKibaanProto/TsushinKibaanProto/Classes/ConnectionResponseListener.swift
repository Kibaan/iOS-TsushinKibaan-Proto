//
//  ConnectionResponseListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/16.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信のレスポンスを受け取るリスナー。主に複数の通信で共通の後処理を行うために使う。
/// （個別の通信完了処理は Connection.connect の引数のコールバックで処理する）
/// レスポンスのバリデーターの役割も兼ねており、`onReceived` 、`onReceivedModel` の返り値はエラー判定に用いられる
///
/// バックグラウンドスレッドから呼び出されるため、UIの操作を行う場合はメインスレッドに切り替える必要がある
public protocol ConnectionResponseListener: class {

    /// レスポンスデータの受信イベント
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - response: 通信レスポンスデータ
    /// - Returns: レスポンスデータが正常の場合 `true`、エラーの場合 `false`
    func onReceived(connection: ConnectionTask, response: Response) -> Bool

    /// レスポンスデータモデルの受信イベント
    /// `ConnectionResponseSpec`で作られたデータモデルを処理する
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - responseModel: 通信レスポンスデータモデル。
    /// - Returns: レスポンスデータモデルが正常の場合 `true`、エラーの場合 `false`
    func onReceivedModel(connection: ConnectionTask, responseModel: Any) -> Bool

    /// 成功コールバック実行直後のイベント
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - responseModel: 通信レスポンスデータモデル。
    func afterSuccess(connection: ConnectionTask, responseModel: Any)
}
