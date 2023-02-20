//
//  GitHubAppsTests.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Foundation
@testable import CreateCore
import XCTest

final class GitHubAppsTests: XCTestCase {
    func testCreateAccessToken() async throws {
        let jwtGenerator = StubJWTGenerator()
        let githubAppsRepository = StubGitHubAppsRepository()
        let core = CreateCore(
            jwtGenerator: jwtGenerator,
            githubAppsRepository: githubAppsRepository
        )

        let accessToken = try await core.createAccessToken(
            for: "dummy",
            repositories: [.init("dummy_repository")],
            permission: .init(contents: .read)
        )

        XCTAssertEqual(accessToken.token, .init("dummy_access_token"))
    }
}
