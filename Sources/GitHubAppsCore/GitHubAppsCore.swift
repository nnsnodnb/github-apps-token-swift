//
//  GitHubAppsCore.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation

public struct GitHubAppsCore {
    // MARK: - Properties
    public let appID: String
    public let privateKey: String

    private let apiClient: any APIClientProtocol
    private let jwtCreator: any JWTCreatable
    private let githubAppsRepository: any GitHubAppsRepositoryProtocol

    // MARK: - Initialize
    public init(
        appID: String,
        privateKey: String,
        apiClient: any APIClientProtocol,
        jwtCreator: any JWTCreatable,
        githubAppsRepository: any GitHubAppsRepositoryProtocol
    ) {
        self.appID = appID
        self.privateKey = privateKey
        self.apiClient = apiClient
        self.jwtCreator = jwtCreator
        self.githubAppsRepository = githubAppsRepository
    }

    // MARK: - Create access token
    public func accessToken(for owner: String, repositories: [Repository], permission: Permission) async throws -> AccessToken {
        let installation = try await getInstallation(for: owner)
        let accessToken = try await createAccessToken(
            installation: installation,
            repositories: repositories,
            permission: permission
        )
        return accessToken
    }

    // MARK: - Revoke access token
    public func revokeAccessToken(_ accessToken: AccessToken) async throws {
        try await githubAppsRepository.revokeAccessToken(accessToken)
    }
}

// MARK: - Private method
private extension GitHubAppsCore {
    func getInstallation(for owner: String) async throws -> Installation {
        let jwtToken = try jwtCreator.generate()
        let installations = try await githubAppsRepository.fetchInstallationApps(jwtToken: jwtToken)
        guard let installation = installations.first(where: { $0.account.login == owner }) else {
            fatalError() // TODO: throw にする
        }
        return installation
    }

    func createAccessToken(
        installation: Installation,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken {
        let jwtToken = try jwtCreator.generate()
        let accessToken = try await githubAppsRepository.createAccessToken(
            jwtToken: jwtToken,
            installationID: installation.id,
            repositories: repositories,
            permission: permission
        )
        return accessToken
    }
}
