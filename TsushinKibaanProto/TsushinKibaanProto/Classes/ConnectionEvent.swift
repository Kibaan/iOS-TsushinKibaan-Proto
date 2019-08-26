//
//  ConnectionEvent.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/25.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

protocol ConnectionEvent {
    func onReceived()
    func afterParse()
    func beforSuccessCallback()
    func afterSuccessCallback()
}
