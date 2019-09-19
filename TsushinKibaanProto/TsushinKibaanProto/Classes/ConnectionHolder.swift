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
    var connections: [Cancellable] = []
    
    func add(connection: Cancellable) {
        connections.append(connection)
    }

    func remove(connection: Cancellable?) {
        connections.removeAll{ $0 === connection }
    }
}
