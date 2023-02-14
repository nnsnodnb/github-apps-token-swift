//
//  GitHubAppsAPI.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public struct GitHubAppsAPI {}

public extension GitHubAppsAPI {
    struct App {}
    struct Installation {}
}

// MARK: - App.Installation
public extension GitHubAppsAPI.App {
    struct Installation {}
}

// MARK: - App.Installation
public extension GitHubAppsAPI.App.Installation {
    struct AccessToken {}
}

// MARK - Installation.Revoke
public extension GitHubAppsAPI.Installation {
    struct Revoke {}
}
