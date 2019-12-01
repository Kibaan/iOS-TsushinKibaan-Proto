//
//  ConnectionErrorListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/12.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信エラーを受け取るリスナー。  
/// afterError以外のエラーコールバックは、Connecion.startの引数に渡したエラーコールバックの実行前にバックグラウンドスレッドで呼ばれる。
///
/// バックグラウンドスレッドから呼び出されるため、UIの操作を行う場合はメインスレッドに切り替える必要がある
public protocol ConnectionErrorListener: class {

    /// 通信エラー時に呼ばれる
    func onNetworkError(error: Error?)

    /// レスポンス内容のパース前のバリデーションエラー時に呼ばれる。
    /// 具体的には、ResponseSpec.isValidResponse で `false` が返却された場合に呼ばれる
    func onResponseError(response: Response)

    /// パースエラー時に呼ばれる
    func onParseError(response: Response)

    /// レスポンスモデルのバリデーションエラー時に呼ばれる。
    /// 具体的には、ConnectionResponseListener.onReceivedModel で `false` が返却された場合に呼ばれる
    func onValidationError(response: Response, responseModel: Any)

    /// Connecion.startの引数に渡したエラーコールバックの実行直後に呼ばれる
    /// Connection.callbackInMainThread がtrueの場合はメインスレッド、falseの場合はバックグラウンドスレッドから呼ばれる
    func afterError(response: Response?, responseModel: Any?, error: ConnectionError)

    /// 通信キャンセル時に呼ばれる
    func onCanceled()
}
