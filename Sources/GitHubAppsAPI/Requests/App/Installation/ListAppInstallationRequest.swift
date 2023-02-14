//
//  ListAppInstallationRequest.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Foundation

public extension GitHubAppsAPI.App.Installation {
    struct List: GitHubAuthorizeRequestType {
        // MARK: - Response
        public typealias Response = ListResponse<Installation>

        // MARK: - Properties
        public let method: HTTPMethod = .get
        public let endpoint: Endpoint = .appInstallations
        public let jwtToken: JWT

        // MARK: - Initialize
        public init(jwtToken: JWT) {
            self.jwtToken = jwtToken
        }
    }
}
