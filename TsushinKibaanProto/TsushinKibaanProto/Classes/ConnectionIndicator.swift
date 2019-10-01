//
//  ConnectionIndicator.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/02.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

protocol ConnectionIndicator {
    func addReferenceCount()
    func removeReferenceCount()
}
