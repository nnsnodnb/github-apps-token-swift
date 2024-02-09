//
//  Runner.swift
//  
//
//  Created by Yuya Oka on 2023/02/20.
//

import Entities
import Foundation
import GitHubAppsAPI

public struct Runner {
    // MARK: - Properties
    public static let version = "1.1.3"

    private let apiClient: APIClientProtocol

    // MARK: - Initialize
    public init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func create(
        appID: String,
        privateKey: URL,
        owner: String,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken.Token {
        let jwtGenerator = try JWTGenerator(appID: appID, privateKey: privateKey)
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        let usecase = GitHubAppsUsecase(jwtGenerator: jwtGenerator, githubAppsRepository: githubAppsRepository)
        let token = try await usecase.createAccessToken(
            for: owner,
            repositories: repositories,
            permission: permission
        )
        return token
    }

    public func revoke(with accessToken: AccessToken.Token) async throws {
        let githubInstallationRepository = GitHubInstallationRepository(apiClient: apiClient)
        let usecase = GitHubInstallationUsecase(githubInstallationRepository: githubInstallationRepository)
        try await usecase.revokeAccessToken(accessToken)
    }
}
