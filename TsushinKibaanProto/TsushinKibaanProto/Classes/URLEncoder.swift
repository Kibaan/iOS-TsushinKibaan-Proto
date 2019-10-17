//
//  URLEncoder.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/21.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 文字列をURLエンコードする
public protocol URLEncoder {
    func encode(_ text: String) -> String
}
