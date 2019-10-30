//
//  ConnectionErrorListener.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/12.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信エラーを受け取るリスナー
///
/// バックグラウンドスレッドから呼び出されるため、UIの操作を行う場合はメインスレッドに切り替える必要がある
public protocol ConnectionErrorListener {
    func onNetworkError(error: Error?)
    func onStatusCodeError(response: Response)
    func onParseError(response: Response)
    func onValidationError(response: Response, dataModel: Any)
}
