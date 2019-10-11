//
//  ConnectionSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// HTTP通信のリクエスト、レスポンスの仕様
public protocol ConnectionSpec: ConnectionRequestSpec, ConnectionResponseSpec {
}

/*
TODO 他にいい名前がないか検討する
- ConnectionInterface
- ConnectionIF
- API
 */
