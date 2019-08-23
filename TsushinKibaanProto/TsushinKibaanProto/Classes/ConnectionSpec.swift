//
//  ConnectionSpec.swift
//  TsushinKibaanProto
//
//  Created by 山本敬太 on 2019/08/09.
//  Copyright © 2019 山本敬太. All rights reserved.
//

import Foundation

protocol ConnectionSpec {
    associatedtype Response

    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String: String] { get }
    var urlQuery: URLQuery? { get }
    
    func makePostData() -> Data?
    
    func isValidStatusCode(_ code: Int) -> Bool
    
    func parseResponse(data: Data) throws -> Response
    
    func isValidResponse(_ data: Response) -> Bool
}

class ConnectionSpec2<Response> {

    var url: String { return "" }
    var httpMethod: HTTPMethod { return .get }
    var headers: [String: String] { return [:] }
    var urlQuery: URLQuery? { return nil }

    func makePostData() -> Data? {
        return nil
    }

    func isValidStatusCode(_ code: Int) -> Bool {
        return code == 200
    }

    func parseResponse(data: Data) throws -> Response {
        fatalError("Not implemanted")
    }

    func isValidResponse(_ data: Response) -> Bool {
        return true
    }
}

/// For type erasure
struct AnyConnectionSpec<T: ConnectionSpec>: ConnectionSpec {
    typealias Response = T.Response

    var url: String {
        return getURL()
    }
    var httpMethod: String {
        return getHTTPMethod()
    }
    var headers: [String: String] {
        return getHeaders()
    }
    var urlQuery: URLQuery? {
        return getURLQuery()
    }

    let getURL: () -> String
    let getHTTPMethod: () -> String
    let getHeaders: () -> [String: String]
    let getURLQuery: () -> URLQuery?

    private let _makePostData: () -> Data?
    private let _isValidStatusCode: (Int) -> Bool
    private let _parseResponse: (Data) throws -> T.Response
    private let _isValidResponse: (T.Response) -> Bool

    init<Inner: ConnectionSpec>(_ inner: Inner) where Response == Inner.Response {

        getURL = { inner.url }
        getHTTPMethod = { inner.httpMethod }
        getHeaders = { inner.headers }
        getURLQuery = { inner.urlQuery }

        _makePostData = inner.makePostData
        _isValidStatusCode = inner.isValidStatusCode
        _parseResponse = inner.parseResponse
        _isValidResponse = inner.isValidResponse
    }

    func makePostData() -> Data? {
        return _makePostData()
    }

    func isValidStatusCode(_ code: Int) -> Bool {
        return _isValidStatusCode(code)
    }

    func parseResponse(data: Data) throws -> T.Response {
        return try _parseResponse(data)
    }

    func isValidResponse(_ data: T.Response) -> Bool {
        return _isValidResponse(data)
    }
}
