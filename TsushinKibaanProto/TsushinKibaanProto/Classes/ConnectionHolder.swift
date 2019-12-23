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

    /// 通信オブジェクトを追加する。
    /// 既に同じものが保持されている場合は何もしない
    ///
    /// - Parameters:
    ///   - connection: 追加する通信オブジェクト
    func add(connection: ConnectionTask) {
        if !contains(connection: connection) {
            connections.append(connection)
        }
    }

    /// 通信オブジェクトを削除する。
    ///
    /// - Parameters:
    ///   - connection: 削除する通信オブジェクト
    func remove(connection: ConnectionTask?) {
        connections.removeAll { $0 === connection }
    }

    /// 指定した通信オブジェクトを保持しているか判定する
    ///
    /// - Parameters:
    ///   - connection: 判定する通信オブジェクト
    /// - Returns: 引数に指定した通信オブエジェクトを保持している場合 `true`
    func contains(connection: ConnectionTask?) -> Bool {
        return connections.contains { $0 === connection }
    }

    /// 保持する全ての通信オブジェクトを削除する。
    func removeAll() {
        connections.removeAll()
    }
}
