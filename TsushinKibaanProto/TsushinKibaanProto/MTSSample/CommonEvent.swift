//
//  CommonEvent.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/09/25.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

class CommonEvent: ConnectionEvent {

    var useMainThread: Bool = true

    func onReceived<T>(connection: ConnectionLifecycle<T>) where T : ConnectionSpec {
    }

    func beforeParse<T>(connection: ConnectionLifecycle<T>, data: Data, statusCode: Int, chain: EventChain) where T : ConnectionSpec {
        
    }

    func afterParse<T>(connection: ConnectionLifecycle<T>, response: T.Response) where T : ConnectionSpec {
        guard let text = response as? String else {
            return
        }
        print(text)
    }

    func beforSuccessCallback<T>(connection: ConnectionLifecycle<T>, response: T.Response, chain: EventChain) where T : ConnectionSpec {

    }

    func beforSuccessCallback(chain: EventChain) {
    }

    func afterSuccessCallback() {
    }

    func beforErrorCallback(chain: EventChain) {
    }

    func afterErrorCallback() {
    }


}
