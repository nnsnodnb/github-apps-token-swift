//
//  StubJWTGenerator.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Entities
import Foundation
@testable import GitHubAppsTokenCore

struct StubJWTGenerator: JWTGeneratorable {
    // MARK: - Properties
    let iat: Date = .init()
    var exp: Date { return Date(timeInterval: 60 * 10, since: iat) }
    let iss: String = "iss"
    var privateKey: Data = .init()

    func generate() throws -> JWT {
        return .init(rawValue: "dummy_jwt")
    }
}
