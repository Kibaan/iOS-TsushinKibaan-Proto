//
//  ConnectionIndicator.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/02.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信インジケーター
/// インジケーターは複数の通信から表示されることを想定して、
/// 単純な表示/非表示の切り替えではなく、参照カウントを増減してカウントが0になったら非表示にする
public protocol ConnectionIndicator {
    func addReferenceCount()
    func removeReferenceCount()
}
