//
//  CreateAppInstallationAccessTokenRequest.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation
import Get

// https://docs.github.com/en/rest/apps/apps#create-an-installation-access-token-for-an-app
public extension GitHubAppsAPI.App.Installation.AccessToken {
    struct Create: GitHubAuthorizeRequestType {
        // MARK: - Response
        public typealias Response = AccessToken

        // MARK: - Body
        private struct Body: Encodable {
            // MARK: - Properties
            let repositories: [Repository]
            let permissions: Permission
        }

        // MARK: - Properties
        public let method: HTTPMethod = .post
        public let endpoint: Endpoint
        public let body: Encodable?
        public let jwtToken: JWT

        // MARK: - Initialize
        public init(
            jwtToken: JWT,
            installationID: Installation.ID,
            repositories: [Repository],
            permission: Permission
        ) {
            self.jwtToken = jwtToken
            self.endpoint = .appInstallationsAccessTokens(installationID)
            self.body = Body(repositories: repositories, permissions: permission)
        }
    }
}
