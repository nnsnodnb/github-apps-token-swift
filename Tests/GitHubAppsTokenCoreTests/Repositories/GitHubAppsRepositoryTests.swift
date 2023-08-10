//
//  GitHubAppsRepositoryTests.swift
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

final class GitHubAppsRepositoryTests: XCTestCase {
    func testFetchInstallationApps() async throws {
        let apiClient = APIClient(baseURL: URL(string: "https://api.github.com"))
        let repository = GitHubAppsRepository(apiClient: apiClient)

        let object: [[String: Any]] = [
            [
                "id": 1234,
                "account": [
                    "id": 9876,
                    "login": "dummy_user",
                    "avatar_url": "https://example.com/avatar_url.jpg",
                    "organizations_url": "https://example.com/organization_url.jpg"
                ] as [String : Any],
                "repository_selection": "select"
            ]
        ]
        let data = try JSONSerialization.data(withJSONObject: object)
        OHHTTPStubsSwift.stub(condition: isPath("/app/installations")) { _ in
            return .init(data: data, statusCode: 200, headers: nil)
        }

        let installations = try await repository.fetchInstallationApps(jwtToken: "dummy_jwt")

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

        XCTAssertEqual(installations, [expect])
    }

    func testCreateAccessToken() async throws {
        let apiClient = APIClient(baseURL: URL(string: "https://api.github.com"))
        let repository = GitHubAppsRepository(apiClient: apiClient)

        let object: [String: Any] = [
            "token": "dummy_token"
        ]
        let data = try JSONSerialization.data(withJSONObject: object)
        OHHTTPStubsSwift.stub(condition: isPath("/app/installations/1234/access_tokens")) { _ in
            return .init(data: data, statusCode: 201, headers: nil)
        }

        let accessToken = try await repository.createAccessToken(
            jwtToken: "dummy_jwt",
            installationID: 1234,
            repositories: ["sample_repository"],
            permission: .init()
        )

        let expect = try Stub.make(AccessToken.self) {
            $0.set(\.token, value: "dummy_token")
        }

        XCTAssertEqual(accessToken, expect)
    }
}
