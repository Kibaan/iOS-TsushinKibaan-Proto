//
//  ViewIndicator.swift
//  TsushinKibaanProto
//
//  Created by Keita Yamamoto on 2019/10/18.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import UIKit

// TODO クラス名が微妙
public class ViewIndicator: ConnectionIndicator {

    let view: UIView
    var referenceCount = 0

    public init(view: UIView) {
        self.view = view
    }

    public func addReferenceCount() {
        referenceCount += 1
        // TODO viewを消す
    }

    public func removeReferenceCount() {
        referenceCount -= 1
        // TODO viewを消す
    }
}
