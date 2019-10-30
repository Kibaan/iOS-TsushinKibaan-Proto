//
//  Polling.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/10/30.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public class Polling: ConnectionListener {

    public init(delay: Double, callback: () -> Void) {
        // TODO ポーリング実装する
    }

    public func onStart(request: Request) {}

    public func onEnd(response: Response?, error: Error?) {

    }
}
