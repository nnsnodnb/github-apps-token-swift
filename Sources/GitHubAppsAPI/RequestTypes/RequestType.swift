//
//  RequestType.swift
//  
//
//  Created by Yuya Oka on 2023/08/10.
//

import Get

public protocol RequestType {
    associatedtype Response: Sendable

    var method: HTTPMethod { get }
    var endpoint: Endpoint { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }

    func buildRequest() -> Get.Request<Response>
}

public extension RequestType where Response: Decodable {
    func buildRequest() -> Get.Request<Response> {
        return Get.Request(
            path: endpoint.rawValue,
            method: method,
            body: body,
            headers: headers
        )
    }
}

public extension RequestType where Response == Void {
    func buildRequest() -> Get.Request<Void> {
        return Get.Request(
            path: endpoint.rawValue,
            method: method,
            body: body,
            headers: headers
        )
    }
}
