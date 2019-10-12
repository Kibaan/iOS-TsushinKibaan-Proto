//
//  ConnectionErrorListener.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/12.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信エラーのリスナー
protocol ConnectionErrorListener {
    
    func onNetworkError(error: Error, response: Response?)
    func onStatusError(statusCode: Int)
    func onParseError()
    func onValidationError(dataModel: Any)
}
