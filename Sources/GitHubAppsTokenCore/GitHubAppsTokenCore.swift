//
//  GitHubAppsTokenCore.swift
//  
//
//  Created by Yuya Oka on 2023/02/20.
//

import CreateCore
import Entities
import Foundation
import GitHubAppsAPI
import RevokeCore

public enum GitHubAppsTokenCore {
    // MARK: - Properties
    public static let version = "1.0.0"

    public static func create(
        appID: String,
        privateKey: URL,
        owner: String,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken.Token {
        let jwtGenerator = try JWTGenerator(appID: appID, privateKey: privateKey)
        let apiClient = APIClient()
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        let core = CreateCore(jwtGenerator: jwtGenerator, githubAppsRepository: githubAppsRepository)

        let accessToken = try await core.createAccessToken(for: owner, repositories: repositories, permission: permission)
        return accessToken.token
    }

    public static func revoke(with accessToken: AccessToken.Token) async throws {
        let apiClient = APIClient()
        let githubInstallationRepository = GitHubInstallationRepository(apiClient: apiClient)
        let core = RevokeCore(githubInstallationRepository: githubInstallationRepository)
        try await core.revokeAccessToken(accessToken)
    }
}

// MARK: - Create
public extension GitHubAppsTokenCore {
    struct Create {
        // MARK: - Properties
        public let appID: String
        public let privateKey: URL
        public let owner: String
        public let repositories: [Repository]
        public let permission: Permission

        // MARK: - Initialize
        public init(
            appID: String,
            privateKey: URL,
            owner: String,
            repositories: [Repository],
            permission: Permission
        ) {
            self.appID = appID
            self.privateKey = privateKey
            self.owner = owner
            self.repositories = repositories
            self.permission = permission
        }
    }
}
