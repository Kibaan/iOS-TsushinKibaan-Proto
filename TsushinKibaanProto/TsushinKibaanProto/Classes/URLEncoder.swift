//
//  URLEncoder.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/08/21.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public protocol URLEncoder {
    func encode(_ text: String) -> String
}

public class DefaultURLEncoder: URLEncoder {
    public init() {}
    public func encode(_ text: String) -> String {
        // NSCharacterSet.urlQueryAllowedは?や&がエンコードされないので使えない
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return text.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }
}
