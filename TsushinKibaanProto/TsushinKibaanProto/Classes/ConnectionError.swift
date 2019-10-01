//
//  ErrorResponse.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/09/18.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public struct ConnectionError {
    let type: ConnectionErrorType
    let response: Response?
    let nativeError: Error?
}
