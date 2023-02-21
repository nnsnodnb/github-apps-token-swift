//
//  GitHubInstallationRepository.swift
//  
//
//  Created by Yuya Oka on 2023/02/20.
//

import Entities
import Foundation
import GitHubAppsAPI

public protocol GitHubInstallationRepositoryProtocol {
    func revokeAccessToken(_ accessToken: AccessToken.Token) async throws
}

public final class GitHubInstallationRepository: GitHubInstallationRepositoryProtocol {
    // MARK: - Properties
    private let apiClient: any APIClientProtocol

    // MARK: - Initialize
    public init(apiClient: any APIClientProtocol) {
        self.apiClient = apiClient
    }

    public func revokeAccessToken(_ accessToken: AccessToken.Token) async throws {
        let request = GitHubAppsAPI.Installation.Revoke.Delete(accessToken: accessToken)
        return try await apiClient.response(for: request)
    }
}
