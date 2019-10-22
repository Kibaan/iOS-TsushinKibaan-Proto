//
//  ConnectionSpec.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// HTTP通信のリクエストおよびレスポンスの仕様
///
/// Specification of a HTTP request and response.
///
public protocol ConnectionSpec: RequestSpec, ResponseSpec {
}
