//
//  EventChain.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/12/25.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 通信完了後イベントの続行・停止ステータス
public enum EventChain: String {
    /// 次の処理に進める
    case proceed
    /// 次の処理を停止する
    case stop
    /// 同一フェーズの処理も含めただちに処理を停止する
    case stopImmediately
}
