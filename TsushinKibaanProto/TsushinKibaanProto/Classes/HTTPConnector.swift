//
//  HTTPConnector.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// HTTP通信の実行処理
public protocol HTTPConnector {
    func execute(request: Request, complete: @escaping (Response?, Error?) -> Void)
    func cancel()
}
