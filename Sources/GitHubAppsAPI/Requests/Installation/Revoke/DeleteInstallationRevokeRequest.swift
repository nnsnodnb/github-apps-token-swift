//
//  DeleteInstallationRevokeRequest.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation
import Get

// https://docs.github.com/en/rest/apps/installations#revoke-an-installation-access-token
public extension GitHubAppsAPI.Installation.Revoke {
    struct Delete: GitHubRequestType {
        // MARK: - Response
        public typealias Response = Void

        // MARK: - Properties
        public let method: HTTPMethod = .delete
        public let endpoint: Endpoint = .installationToken
        public let body: Encodable? = nil
        public var headers: [String: String]? {
            return [
                "Accept": "application/vnd.github.json",
                "Authorization": "Bearer \(accessToken.rawValue)"
            ]
        }

        private let accessToken: AccessToken.Token

        // MARK: - Initialize
        public init(accessToken: AccessToken.Token) {
            self.accessToken = accessToken
        }
    }
}
