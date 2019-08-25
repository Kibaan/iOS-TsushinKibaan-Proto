//
//  ViewController.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let con = Connection2(spec: HogeSpec())

        con.test(callback: { response in
            print(response.mmm)
        })
    }
}

struct HogeResponse {
    let mmm: String
}

class HogeSpec: ConnectionSpec {
    
    typealias Response = HogeResponse

    var url: String {
        return ""
    }

    var httpMethod: HTTPMethod {
        return .get
    }

    var headers: [String : String]{
        return [:]
    }

    var urlQuery: URLQuery? {
        return nil
    }


    init() {}

    func makePostData() -> Data? {
        return nil
    }

    func isValidStatusCode(_ code: Int) -> Bool {
        return true
    }

    func parseResponse(data: Data, statusCode: Int) throws -> HogeResponse {
        return HogeResponse(mmm: "test")
    }

    func isValidResponse(_ data: HogeResponse) -> Bool {
        return true
    }

}
