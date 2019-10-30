//
//  Polling.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/10/30.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public class Polling: ConnectionListener {

    let delay: Double
    let callback: () -> Void

    public init(delay: Double, callback: @escaping () -> Void) {
        self.delay = delay
        self.callback = callback
    }

    public func onStart(request: Request) {}

    public func onEnd(response: Response?, responseModel: Any?, error: ConnectionError?) {

    }
}
