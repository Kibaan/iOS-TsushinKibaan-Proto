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
    var timer: Timer?

    public init(delay: Double, callback: @escaping () -> Void) {
        self.delay = delay
        self.callback = callback
    }

    public func onStart(connection: ConnectionTask, request: Request) {}

    public func onEnd(connection: ConnectionTask, response: Response?, responseModel: Any?, error: ConnectionError?) {
        if error == nil || error?.type == ConnectionErrorType.network {
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { timer in
                timer.invalidate()
                self.callback()
            }
        } else if error?.type == ConnectionErrorType.canceled {
            timer?.invalidate()
        }
    }
}
