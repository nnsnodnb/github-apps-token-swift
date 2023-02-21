//
//  GitHubInstallationUsecase.swift
//  
//
//  Created by Yuya Oka on 2023/02/21.
//

import Entities
import Foundation

protocol GitHubInstallationUsecaseProtocol {
    func revokeAccessToken(_ accessToken: AccessToken.Token) async throws
}

final class GitHubInstallationUsecase: GitHubInstallationUsecaseProtocol {
    // MARK: - Properties
    private let githubInstallationRepository: any GitHubInstallationRepositoryProtocol

    // MARK: - Initialize
    public init(githubInstallationRepository: any GitHubInstallationRepositoryProtocol) {
        self.githubInstallationRepository = githubInstallationRepository
    }

    func revokeAccessToken(_ accessToken: AccessToken.Token) async throws {
        try await githubInstallationRepository.revokeAccessToken(accessToken)
    }
}
