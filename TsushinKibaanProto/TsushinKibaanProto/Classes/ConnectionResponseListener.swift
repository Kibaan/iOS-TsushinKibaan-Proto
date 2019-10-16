//
//  ConnectionResponseListener.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/10/16.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public protocol ConnectionResponseListener {

    func onReceived(response: Response)
    func onReceivedModel(responseModel: Any)
}
