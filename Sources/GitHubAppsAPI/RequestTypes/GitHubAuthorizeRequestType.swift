//
//  GitHubAuthorizeRequestType.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation

public protocol GitHubAuthorizeRequestType: GitHubRequestType {
    var jwtToken: JWT { get }
}

public extension GitHubAuthorizeRequestType {
    var headers: [String: String]? {
        return [
            "Accept": "application/vnd.github+json",
            "Authorization": "Bearer \(jwtToken.rawValue)"
        ]
    }
}
