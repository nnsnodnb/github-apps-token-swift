//
//  ListAppInstallationRequest.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation
import Get

// https://docs.github.com/en/rest/reference/apps#get-a-repository-installation-for-the-authenticated-app
public extension GitHubAppsAPI.App.Installation {
    struct List: GitHubAuthorizeRequestType {
        // MARK: - Response
        public typealias Response = [Installation]

        // MARK: - Properties
        public let method: HTTPMethod = .get
        public let endpoint: Endpoint = .appInstallations
        public let body: Encodable? = nil
        public let jwtToken: JWT

        // MARK: - Initialize
        public init(jwtToken: JWT) {
            self.jwtToken = jwtToken
        }
    }
}
