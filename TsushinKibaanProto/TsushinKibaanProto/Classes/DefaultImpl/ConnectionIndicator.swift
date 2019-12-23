//
//  ConnectionIndicator.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/10/22.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import UIKit

/// 通信インジケーター。
/// インジケーターは複数の通信で使われることを想定して、
/// 単純な表示/非表示の切り替えではなく、参照カウントを増減してカウントが0になったら非表示にする方式にする。
public class ConnectionIndicator: ConnectionListener {

    var referenceCount = 0

    let view: UIView
    let indicatorView: UIActivityIndicatorView?

    init(view: UIView, indicatorView: UIActivityIndicatorView? = nil) {
        self.view = view
        self.indicatorView = indicatorView
    }

    public func onStart(connection: ConnectionTask, request: Request) {
        referenceCount += 1
        updateViewInMainThread()
    }

    public func onEnd(connection: ConnectionTask, response: Response?, responseModel: Any?, error: ConnectionError?) {
        referenceCount -= 1
        updateViewInMainThread()
    }

    func updateViewInMainThread() {
        DispatchQueue.main.async {
            self.updateView()
        }
    }

    func updateView() {
        view.isHidden = (referenceCount <= 0)
        if view.isHidden {
            indicatorView?.stopAnimating()
        } else if indicatorView?.isAnimating == false {
            indicatorView?.startAnimating()
        }
    }
}
