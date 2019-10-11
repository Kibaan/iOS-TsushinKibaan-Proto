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
    
    func afterParse<T>(connection: ConnectionLifecycle<T>, response: T.ResponseModel) where T : ConnectionSpec {
        
    }
    
    func beforSuccessCallback<T>(connection: ConnectionLifecycle<T>, response: T.ResponseModel, chain: EventChain) where T : ConnectionSpec {
        
    }
    
    func afterSuccessCallback<T>(connection: ConnectionLifecycle<T>) where T : ConnectionSpec {
        
    }
    
    func beforErrorCallback<T>(connection: ConnectionLifecycle<T>, chain: EventChain) where T : ConnectionSpec {
        
    }
    
    func afterErrorCallback<T>(connection: ConnectionLifecycle<T>) where T : ConnectionSpec {
        
    }
}
