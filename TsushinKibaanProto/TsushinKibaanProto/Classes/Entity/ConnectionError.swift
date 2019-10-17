//
//  ErrorResponse.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/09/18.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

public struct ConnectionError {
    let type: ConnectionErrorType
    let response: Response?
    let nativeError: Error?
}
