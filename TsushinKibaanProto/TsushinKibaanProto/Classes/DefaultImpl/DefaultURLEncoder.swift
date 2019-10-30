//
//  DefaultURLEncoder.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/10/06.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import Foundation

/// URLエンコードの標準実装
public class DefaultURLEncoder: URLEncoder {
    public init() {}
    public func encode(_ text: String) -> String {
        // NSCharacterSet.urlQueryAllowedは?や&がエンコードされないので使えない
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return text.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }
}
