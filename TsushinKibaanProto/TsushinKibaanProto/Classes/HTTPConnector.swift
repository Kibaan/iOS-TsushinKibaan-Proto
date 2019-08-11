//
//  HTTPConnector.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

protocol HTTPConnector {
    var timeoutIntervalForRequest: TimeInterval { get set }
    var timeoutIntervalForResource: TimeInterval { get set }
    var isCancelled: Bool { get }
    
    func execute(request: URLRequest, complete: @escaping (Data?, URLResponse?, Error?) -> Void)
    func cancel()
}
