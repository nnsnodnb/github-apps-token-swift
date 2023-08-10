//
//  GitHubInstallationRepositoryTests.swift
//  
//
//  Created by Yuya Oka on 2023/02/21.
//

import Entities
@testable import GitHubAppsTokenCore
import Foundation
import StubKit
import XCTest

final class GitHubInstallationRepositoryTests: XCTestCase {
    func testRevokeAccessToken() async throws {
        let apiClient = StubAPIClient(responseDecodable: "stub")
        let repository = GitHubInstallationRepository(apiClient: apiClient)

        XCTAssertNoThrow {
            try await repository.revokeAccessToken(.init("dummy_token"))
        }
    }
}
