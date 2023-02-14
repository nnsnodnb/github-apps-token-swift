//
//  GitHubAuthorizeRequestType.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Foundation

public protocol GitHubAuthorizeRequestType: GitHubRequestType {
    var jwtToken: JWT { get }
}

public extension GitHubAuthorizeRequestType {
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer \(jwtToken.rawValue)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        urlRequest.timeoutInterval = 20
        return urlRequest
    }
}
