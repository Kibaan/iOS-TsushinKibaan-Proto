//
//  ConnectionHolder.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/09/11.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 実行中の通信オブジェクトを保持するためのコンテナ
/// 通信の一括キャンセルや通信オブジェクトが通信中に解放されないよう保持する役割を持つ
public class ConnectionHolder {
    static var shared = ConnectionHolder()
    var connections: [ConnectionTask] = []

    func add(connection: ConnectionTask) {
        connections.append(connection)
    }

    func remove(connection: ConnectionTask?) {
        connections.removeAll { $0 === connection }
    }

    func removeAll() {
        connections.removeAll()
    }
}
