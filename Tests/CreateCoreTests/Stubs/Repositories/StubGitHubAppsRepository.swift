//
//  StubGitHubAppsRepository.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Entities
import Foundation
@testable import CreateCore
import StubKit
import XCTest

final class StubGitHubAppsRepository: GitHubAppsRepositoryProtocol {
    func fetchInstallationApps(jwtToken: JWT) async throws -> [Installation] {
        let installation = try Stub.make(Installation.self) {
            let account = try Stub.make(Account.self) {
                $0.set(\.login, value: "dummy")
            }
            $0.set(\.account, value: account)
        }
        let installations = try Stub.make([Installation].self)
        return installations + [installation]
    }

    func createAccessToken(
        jwtToken: JWT,
        installationID: Installation.ID,
        repositories: [Repository],
        permission: Permission
    ) async throws -> AccessToken {
        let accessToken = try Stub.make(AccessToken.self) {
            $0.set(\.token, value: "dummy_access_token")
        }
        return accessToken
    }
}
