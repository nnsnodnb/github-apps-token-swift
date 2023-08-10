//
//  GitHubAppsRepositoryTests.swift
//  
//
//  Created by Yuya Oka on 2023/02/21.
//

import Entities
@testable import GitHubAppsTokenCore
import Foundation
import StubKit
import XCTest

final class GitHubAppsRepositoryTests: XCTestCase {
    func testFetchInstallationApps() async throws {
        let expect = try Stub.make(Installation.self) {
            $0.set(\.id, value: 1234)
            let account = try Stub.make(Account.self) {
                $0.set(\.id, value: 9876)
                $0.set(\.login, value: "dummy_user")
                $0.set(\.avatarURL, value: URL(string: "https://example.com/avatar_url.jpg")!)
                $0.set(\.organizationsURL, value: URL(string: "https://example.com/organization_url.jpg")!)
            }
            $0.set(\.account, value: account)
            $0.set(\.repositorySelection, value: "select")
        }
        let apiClient = StubAPIClient(responseDecodable: [expect])
        let repository = GitHubAppsRepository(apiClient: apiClient)

        let installations = try await repository.fetchInstallationApps(jwtToken: "dummy_jwt")

        XCTAssertEqual(installations, [expect])
    }

    func testCreateAccessToken() async throws {
        let expect = try Stub.make(AccessToken.self) {
            $0.set(\.token, value: "dummy_token")
        }
        let apiClient = StubAPIClient(responseDecodable: expect)
        let repository = GitHubAppsRepository(apiClient: apiClient)

        let accessToken = try await repository.createAccessToken(
            jwtToken: "dummy_jwt",
            installationID: 1234,
            repositories: ["sample_repository"],
            permission: .init()
        )

        XCTAssertEqual(accessToken, expect)
    }
}
