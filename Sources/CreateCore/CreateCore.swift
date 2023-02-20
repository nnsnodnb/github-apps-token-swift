//
//  CreateCore.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation

public struct CreateCore {
    // MARK: - Properties
    public static let version = "1.0.0"

    private let jwtGenerator: any JWTGeneratorable
    private let githubAppsRepository: any GitHubAppsRepositoryProtocol

    // MARK: - Initialize
    public init(
        jwtGenerator: any JWTGeneratorable,
        githubAppsRepository: any GitHubAppsRepositoryProtocol
    ) {
        self.jwtGenerator = jwtGenerator
        self.githubAppsRepository = githubAppsRepository
    }

    // MARK: - Create access token
    public func createAccessToken(
        for user: String,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken {
        let installation = try await getInstallation(for: user)
        let accessToken = try await createAccessToken(
            installation: installation,
            repositories: repositories,
            permission: permission
        )
        return accessToken
    }
}

// MARK: - Private method
private extension CreateCore {
    func getInstallation(for owner: String) async throws -> Installation {
        let jwtToken = try jwtGenerator.generate()
        let installations = try await githubAppsRepository.fetchInstallationApps(jwtToken: jwtToken)
        guard let installation = installations.first(where: { $0.account.login == owner }) else {
            throw Error.notFoundInstallation
        }
        return installation
    }

    func createAccessToken(
        installation: Installation,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken {
        let jwtToken = try jwtGenerator.generate()
        let accessToken = try await githubAppsRepository.createAccessToken(
            jwtToken: jwtToken,
            installationID: installation.id,
            repositories: repositories,
            permission: permission
        )
        return accessToken
    }
}

// MARK: - Error
public extension CreateCore {
    enum Error: Swift.Error, CustomStringConvertible {
        case notFoundInstallation

        // MARK: - Properties
        public var description: String {
            switch self {
            case .notFoundInstallation:
                return "指定したユーザのInstallationが見つかりません"
            }
        }
    }
}
