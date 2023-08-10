//
//  GitHubRequestType.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public protocol GitHubRequestType: RequestType {
}

public extension GitHubRequestType {
    var path: String {
        return endpoint.rawValue
    }
    var headers: [String: String]? {
        return [
            "Accept": "application/vnd.github.json"
        ]
    }
}
