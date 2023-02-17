//
//  CreateAppInstallationAccessTokenRequest.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Entities
import Foundation

// https://docs.github.com/en/rest/apps/apps#create-an-installation-access-token-for-an-app
public extension GitHubAppsAPI.App.Installation.AccessToken {
    struct Create: GitHubAuthorizeRequestType {
        // MARK: - Response
        public typealias Response = AccessToken

        // MARK: - Properties
        public let method: HTTPMethod = .post
        public let endpoint: Endpoint
        public let jwtToken: JWT

        public var parameters: Any? {
            return [
                "repositories": repositories.map { $0.rawValue },
                "permissions": permission.jsonObject
            ]
        }

        private let repositories: [Repository]
        private let permission: Permission

        // MARK: - Initialize
        public init(
            jwtToken: JWT,
            installationID: Installation.ID,
            repositories: [Repository],
            permission: Permission
        ) {
            self.jwtToken = jwtToken
            self.endpoint = .appInstallationsAccessTokens(installationID)
            self.repositories = repositories
            self.permission = permission
        }
    }
}
