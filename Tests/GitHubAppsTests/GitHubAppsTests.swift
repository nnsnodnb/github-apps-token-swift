//
//  GitHubAppsTests.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Foundation
@testable import GitHubApps
import XCTest

final class GitHubAppsTests: XCTestCase {
    func testCreateAccessToken() async throws {
        let jwtGenerator = StubJWTGenerator()
        let githubAppsRepository = StubGitHubAppsRepository()
        let apps = GitHubApps(
            jwtGenerator: jwtGenerator,
            githubAppsRepository: githubAppsRepository
        )

        let accessToken = try await apps.createAccessToken(
            for: "dummy",
            repositories: [.init("dummy_repository")],
            permission: .init(contents: .read)
        )

        XCTAssertEqual(accessToken.token, .init("dummy_access_token"))
    }
}
