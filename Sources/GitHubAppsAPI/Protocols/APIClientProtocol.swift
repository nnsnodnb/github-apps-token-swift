//
//  APIClientProtocol.swift
//  
//
//  Created by Yuya Oka on 2023/02/15.
//

import Foundation

public protocol APIClientProtocol {
    func response<Request: GitHubRequestType>(for request: Request) async throws -> Request.Response
}
