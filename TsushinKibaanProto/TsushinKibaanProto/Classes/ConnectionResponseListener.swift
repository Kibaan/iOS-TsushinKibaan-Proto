//
//  ConnectionResponseListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/16.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信のレスポンスを受け取るリスナー
/// 主に複数の通信で共通の後処理を行うために使う
/// （個別の通信完了処理は ConnectionLifecycle.connect の引数のコールバックで処理する）
/// レスポンスのバリデーターの役割も兼ねており、`onReceived` 、`onReceivedModel` の返り値はエラー判定に用いられる
///
public protocol ConnectionResponseListener {

    /// レスポンスデータの受信イベント
    ///
    /// - Parameters:
    ///   - response: 通信レスポンスデータ
    /// - Returns: レスポンスデータが正常の場合 `true`、エラーの場合 `false`
    func onReceived(response: Response) -> Bool
    
    /// レスポンスデータモデルの受信イベント
    /// `ConnectionResponseSpec`で作られたデータモデルを処理する
    ///
    /// - Parameters:
    ///   - responseModel: 通信レスポンスデータモデル。
    /// - Returns: レスポンスデータモデルが正常の場合 `true`、エラーの場合 `false`
    func onReceivedModel(responseModel: Any) -> Bool
    
    /// 成功コールバック実行後のイベント
    func afterSuccess(responseModel: Any)
}
