//
//  APIClientProtocol.swift
//  
//
//  Created by Yuya Oka on 2023/02/15.
//

import Foundation

public protocol APIClientProtocol {
    func response<R: RequestType>(for request: R) async throws -> R.Response where R.Response: Decodable
    func response<R: RequestType>(for request: R) async throws where R.Response == Void
}
