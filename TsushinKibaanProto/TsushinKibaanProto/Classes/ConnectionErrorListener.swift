//
//  ConnectionErrorListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/12.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信エラーを受け取るリスナー。
/// afterError以外のエラーコールバックは、Connecionに渡したエラーコールバックの実行前にバックグラウンドスレッドで呼ばれる。
///
/// バックグラウンドスレッドから呼び出されるため、UIの操作を行う場合はメインスレッドに切り替える必要がある
public protocol ConnectionErrorListener: class {

    /// 通信エラー時に呼ばれる
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - error: エラー情報
    func onNetworkError(connection: ConnectionTask, error: Error?) -> EventChain

    /// レスポンス内容のパース前のバリデーションエラー時に呼ばれる。
    /// 具体的には、ResponseSpec.isValidResponse で `false` が返却された場合に呼ばれる
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - response: HTTPレスポンスの情報
    func onResponseError(connection: ConnectionTask, response: Response) -> EventChain

    /// パースエラー時に呼ばれる
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - response: HTTPレスポンスの情報
    func onParseError(connection: ConnectionTask, response: Response) -> EventChain

    /// レスポンスモデルのバリデーションエラー時に呼ばれる。
    /// 具体的には、ConnectionResponseListener.onReceivedModel で `false` が返却された場合に呼ばれる
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - response: HTTPレスポンスの情報
    ///   - responseModel: パースされたレスポンスデータモデル
    func onValidationError(connection: ConnectionTask, response: Response, responseModel: Any) -> EventChain

    /// Connecion.startの引数に渡したエラーコールバックの実行直後に呼ばれる
    /// Connection.callbackInMainThread がtrueの場合はメインスレッド、falseの場合はバックグラウンドスレッドから呼ばれる
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    ///   - response: HTTPレスポンスの情報
    ///   - responseModel: パースされたレスポンスデータモデル
    ///   - error: エラー情報
    func afterError(connection: ConnectionTask, response: Response?, responseModel: Any?, error: ConnectionError)

    /// 通信キャンセル時に呼ばれる
    ///
    /// - Parameters:
    ///   - connection: 通信オブジェクト
    func onCanceled(connection: ConnectionTask)
}
