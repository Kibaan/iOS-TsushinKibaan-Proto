//
//  HTTPMethod.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/08/23.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    
    var stringValue: String {
        return rawValue.uppercased()
    }
}
