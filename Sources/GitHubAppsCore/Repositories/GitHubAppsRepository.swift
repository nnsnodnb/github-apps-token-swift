//
//  GitHubAppsRepository.swift
//  
//
//  Created by Yuya Oka on 2023/02/15.
//

import Entities
import Foundation
import GitHubAppsAPI

public protocol GitHubAppsRepositoryProtocol {
    func fetchInstallationApps(jwtToken: JWT) async throws -> [Installation]
    func createAccessToken(
        jwtToken: JWT,
        installationID: Installation.ID,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken
    func revokeAccessToken(_ accessToken: AccessToken) async throws
}

public final class GitHubAppsRepository: GitHubAppsRepositoryProtocol {
    // MARK: - Properties
    private let apiClient: any APIClientProtocol

    // MARK: - Initialize
    init(apiClient: any APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func fetchInstallationApps(jwtToken: JWT) async throws -> [Installation] {
        let request = GitHubAppsAPI.App.Installation.List(jwtToken: jwtToken)
        return try await apiClient.response(for: request)
    }

    public func createAccessToken(
        jwtToken: JWT,
        installationID: Installation.ID,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken {
        let request = GitHubAppsAPI.App.Installation.AccessToken.Create(
            jwtToken: jwtToken,
            installationID: installationID,
            repositories: repositories,
            permission: permission
        )
        return try await apiClient.response(for: request)
    }

    public func revokeAccessToken(_ accessToken: AccessToken) async throws {
        let request = GitHubAppsAPI.Installation.Revoke.Delete(accessToken: accessToken)
        return try await apiClient.response(for: request)
    }
}
