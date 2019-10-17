//
//  ConnectionIndicator.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/02.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 通信インジケーター
public protocol ConnectionIndicator {
    func addReferenceCount()
    func removeReferenceCount()
}
