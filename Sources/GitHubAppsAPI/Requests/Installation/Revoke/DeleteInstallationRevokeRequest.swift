//
//  DeleteInstallationRevokeRequest.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Entities
import Foundation

public extension GitHubAppsAPI.Installation.Revoke {
    struct Delete: GitHubRequestType {
        // MARK: - Response
        public typealias Response = Void

        // MARK: - Properties
        public let method: HTTPMethod = .delete
        public let endpoint: Endpoint = .installationToken

        public var headerFields: [String: String] {
            return [
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
