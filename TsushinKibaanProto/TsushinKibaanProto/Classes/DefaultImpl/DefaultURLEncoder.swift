//
//  DefaultURLEncoder.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/06.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

public class DefaultURLEncoder: URLEncoder {
    public init() {}
    public func encode(_ text: String) -> String {
        // NSCharacterSet.urlQueryAllowedは?や&がエンコードされないので使えない
        var allowedCharacterSet = CharacterSet.alphanumerics
        allowedCharacterSet.insert(charactersIn: "-._~")
        return text.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
    }
}
