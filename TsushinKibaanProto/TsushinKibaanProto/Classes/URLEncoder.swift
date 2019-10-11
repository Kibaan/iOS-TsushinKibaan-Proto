//
//  URLEncoder.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/08/21.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

/// 文字列をURLエンコードする
public protocol URLEncoder {
    func encode(_ text: String) -> String
}
