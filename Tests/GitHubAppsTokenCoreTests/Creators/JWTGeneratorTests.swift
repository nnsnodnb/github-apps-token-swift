//
//  JWTGeneratorTests.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Foundation
@testable import GitHubAppsTokenCore
import JWTKit
import XCTest

final class JWTGeneratorTests: XCTestCase {
    func testGenerate() throws {
        guard let privateKeyURL = Bundle.module.url(forResource: "dummy", withExtension: "pem") else {
            XCTFail("Not found dummy.pem in resource.")
            return
        }
        let jwtCreator = try JWTGenerator(appID: "dummy", privateKey: privateKeyURL)
        let token = try jwtCreator.generate()

        guard let publicKeyURL = Bundle.module.url(forResource: "dummy", withExtension: "pub") else {
            XCTFail("Not found dummy.pub in resource.")
            return
        }
        let publicKey = try Data(contentsOf: publicKeyURL, options: .alwaysMapped)
        let signers = JWTSigners()
        let key = try RSAKey.public(pem: publicKey)
        signers.use(.rs256(key: key))
        let payload = try signers.verify(token.rawValue, as: JWTGenerator.Payload.self)

        XCTAssertEqual(payload.issuer.value, "dummy")
    }
}
