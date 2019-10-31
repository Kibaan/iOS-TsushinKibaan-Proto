//
//  ConnectionErrorListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/12.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信エラーを受け取るリスナー
/// afterError以外のエラーコールバックは、Connecion.startの引数に渡したエラーコールバックの直前にバックグラウンドスレッドで呼ばれる。
///
/// バックグラウンドスレッドから呼び出されるため、UIの操作を行う場合はメインスレッドに切り替える必要がある
public protocol ConnectionErrorListener {
    func onNetworkError(error: Error?)
    func onResponseError(response: Response)
    func onParseError(response: Response)
    func onValidationError(response: Response, responseModel: Any)

    /// Connecion.startの引数に渡したエラーコールバックの実行直後に呼ばれる
    /// Connection.callbackInMainThread がtrueの場合はメインスレッド、falseの場合はバックグラウンドスレッドから呼ばれる
    func afterError(response: Response?, responseModel: Any?, error: ConnectionError)

    func onCanceled()
}
