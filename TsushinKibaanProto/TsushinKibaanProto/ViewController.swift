//
//  ViewController.swift
//  TsushinKibaanProto
//
//  Created by Yamamoto Keita on 2019/08/09.
//  Copyright © 2019 Yamamoto Keita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let spec = SimplestSpec()

        Connection(spec) { response in
            print(response)
        }.start()
    }
}
