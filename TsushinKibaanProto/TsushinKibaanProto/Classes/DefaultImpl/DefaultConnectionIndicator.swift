//
//  DefaultConnectionIndicator.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/06.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import UIKit

class DefaultConnectionIndicator: ConnectionIndicator {
    var referenceCount = 0
    
    let view: UIView
    let acitivityIndicator: UIActivityIndicatorView?
    
    init(view: UIView, acitivityIndicator: UIActivityIndicatorView? = nil) {
        self.view = view
        self.acitivityIndicator = acitivityIndicator
    }
    
    func addReferenceCount() {
        referenceCount += 1
        updateView()
    }
    
    func removeReferenceCount() {
        referenceCount -= 1
        updateView()
    }
    
    func updateView() {
        view.isHidden = (referenceCount <= 0)
    }
}
