//
//  RevokeCore.swift
//  
//
//  Created by Yuya Oka on 2023/02/20.
//

import Entities
import Foundation
import GitHubAppsAPI

public struct RevokeCore {
    // MARK: - Properties
    private let githubInstallationRepository: any GitHubInstallationRepositoryProtocol

    // MARK: - Initialize
    public init(githubInstallationRepository: any GitHubInstallationRepositoryProtocol) {
        self.githubInstallationRepository = githubInstallationRepository
    }

    public func revokeAccessToken(_ accessToken: AccessToken.Token) async throws {
        try await githubInstallationRepository.revokeAccessToken(accessToken)
    }
}
