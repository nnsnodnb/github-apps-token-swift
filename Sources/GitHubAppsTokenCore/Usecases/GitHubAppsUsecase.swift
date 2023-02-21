//
//  GitHubAppsUsecase.swift
//  
//
//  Created by Yuya Oka on 2023/02/21.
//

import Entities
import Foundation

protocol GitHubAppsUsecaseProtocol {
    func createAccessToken(
        for owner: String,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken.Token
}

final class GitHubAppsUsecase: GitHubAppsUsecaseProtocol {
    // MARK: - Properties
    private let jwtGenerator: any JWTGeneratorable
    private let githubAppsRepository: any GitHubAppsRepositoryProtocol

    // MARK: - Initialize
    init(jwtGenerator: any JWTGeneratorable, githubAppsRepository: any GitHubAppsRepositoryProtocol) {
        self.jwtGenerator = jwtGenerator
        self.githubAppsRepository = githubAppsRepository
    }

    func createAccessToken(
        for owner: String,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken.Token {
        let installation: Installation = try await {
            let jwtToken = try jwtGenerator.generate()
            let installations = try await githubAppsRepository.fetchInstallationApps(jwtToken: jwtToken)
            guard let installation = installations.first(where: { $0.account.login == owner }) else {
                throw Installation.Error.notFound
            }
            return installation
        }()
        let accessToken: AccessToken.Token = try await {
            let jwtToken = try jwtGenerator.generate()
            let accessToken = try await githubAppsRepository.createAccessToken(
                jwtToken: jwtToken,
                installationID: installation.id,
                repositories: repositories,
                permission: permission
            )
            return accessToken.token
        }()

        return accessToken
    }
}
