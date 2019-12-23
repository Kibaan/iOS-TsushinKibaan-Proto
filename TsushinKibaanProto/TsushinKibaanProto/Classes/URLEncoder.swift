//
//  URLEncoder.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/21.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 文字列をURLエンコードする。
/// URLのクエリパラメーターのエンコードに使われる。
///
/// クエリパラメーターのエンコード方法は標準仕様が存在するが、標準仕様に従っていないシステムもあるためプロトコルにして拡張可能にしている。
public protocol URLEncoder {
    func encode(_ text: String) -> String
}
