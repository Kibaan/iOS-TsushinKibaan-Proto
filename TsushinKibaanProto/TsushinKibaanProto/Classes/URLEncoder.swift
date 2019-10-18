//
//  URLEncoder.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/21.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// 文字列をURLエンコードする
/// URLのクエリパラメーターのエンコードに使われる
/// クエリパラメーターのエンコードは一般的にUTF-8だが、
/// 古いシステムでは他の文字コードが使われている場合があるためプロトコルにしている
public protocol URLEncoder {
    func encode(_ text: String) -> String
}
