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

    func onReceived<T: ConnectionSpec>(connection: ConnectionLifecycle<T>)

    func beforeParse<T: ConnectionSpec>(connection: ConnectionLifecycle<T>, data: Data, statusCode: Int, chain: EventChain)
    func afterParse<T: ConnectionSpec>(connection: ConnectionLifecycle<T>, response: T.Response)

    func beforSuccessCallback<T: ConnectionSpec>(connection: ConnectionLifecycle<T>, response: T.Response, chain: EventChain)
    func afterSuccessCallback<T: ConnectionSpec>(connection: ConnectionLifecycle<T>)

    func beforErrorCallback<T: ConnectionSpec>(connection: ConnectionLifecycle<T>, chain: EventChain)
    func afterErrorCallback<T: ConnectionSpec>(connection: ConnectionLifecycle<T>)
}

public protocol ConnectionEvent2 {
    associatedtype Response
    
    func onSuccess(response: Response)
}