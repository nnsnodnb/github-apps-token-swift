//
//  GitHubAppsTokenCore.swift
//  
//
//  Created by Yuya Oka on 2023/02/20.
//

import Entities
import Foundation
import GitHubAppsAPI

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
        let apiClient = APIClient(baseURL: URL(string: "https://api.github.com"))
        let githubAppsRepository = GitHubAppsRepository(apiClient: apiClient)
        let usecase = GitHubAppsUsecase(jwtGenerator: jwtGenerator, githubAppsRepository: githubAppsRepository)
        let token = try await usecase.createAccessToken(
            for: owner,
            repositories: repositories,
            permission: permission
        )
        return token
    }

    public static func revoke(with accessToken: AccessToken.Token) async throws {
        let apiClient = APIClient(baseURL: URL(string: "https://api.github.com"))
        let githubInstallationRepository = GitHubInstallationRepository(apiClient: apiClient)
        let usecase = GitHubInstallationUsecase(githubInstallationRepository: githubInstallationRepository)
        try await usecase.revokeAccessToken(accessToken)
    }
}
