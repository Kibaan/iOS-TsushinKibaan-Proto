//
//  ConnectionListener.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信の開始と終了時の処理
public protocol ConnectionListener {
    func onStart()
    func onEnd()
}
