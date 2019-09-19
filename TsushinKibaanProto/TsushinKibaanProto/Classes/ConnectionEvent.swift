//
//  ConnectionEvent.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/25.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public protocol ConnectionEvent {
    var useMainThread: Bool { get }

    // spec: Spec

    func onReceived<T: ConnectionSpec>(connection: Connection<T>)

    /// パースの前
    func beforeParse(chain: EventChain)
    func afterParse()

    func beforSuccessCallback(chain: EventChain)
    func afterSuccessCallback()

    func beforErrorCallback(chain: EventChain)
    func afterErrorCallback()
}
