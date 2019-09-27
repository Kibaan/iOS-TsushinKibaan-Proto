//
//  ConnectionHolder.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/09/11.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public class ConnectionHolder {
    static var shared = ConnectionHolder()
    var connections: [ConnectionTask] = []
    
    func add(connection: ConnectionTask) {
        connections.append(connection)
    }

    func remove(connection: ConnectionTask?) {
        connections.removeAll{ $0 === connection }
    }
}
