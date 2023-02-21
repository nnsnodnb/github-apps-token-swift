//
//  GitHubInstallationRepositoryTests.swift
//  
//
//  Created by Yuya Oka on 2023/02/21.
//

import Entities
@testable import GitHubAppsTokenCore
import OHHTTPStubsSwift
import Foundation
import StubKit
import XCTest

final class GitHubInstallationRepositoryTests: XCTestCase {
    func testRevokeAccessToken() async throws {
        let apiClient = APIClient()
        let repository = GitHubInstallationRepository(apiClient: apiClient)

        OHHTTPStubsSwift.stub(condition: isPath("/installation/token")) { _ in
            return .init(data: .init(), statusCode: 204, headers: nil)
        }

        XCTAssertNoThrow {
            try await repository.revokeAccessToken(.init("dummy_token"))
        }
    }
}
