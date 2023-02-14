//
//  Endpoint.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public enum Endpoint {
    // MARK: - App
    case appInstallations
    case appInstallationsAccessTokens(Installation.ID)
    // MARK: - Installation
    case installationToken

    // MARK: - Properties
    var rawValue: String {
        switch self {
        case .appInstallations:
            return "/app/installations"
        case let .appInstallationsAccessTokens(installationID):
            return "/app/installations/\(installationID.rawValue)/access_tokens"
        case .installationToken:
            return "/installation/token"
        }
    }
}
