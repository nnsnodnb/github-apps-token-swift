//
//  TestJWTCreator.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Foundation
@testable import GitHubApps
import JWTKit
import XCTest

final class TestJWTCreator: XCTestCase {
    func testGenerate() throws {
        guard let privateKeyURL = Bundle.module.url(forResource: "dummy", withExtension: "pem") else {
            XCTFail("Not found dummy.pem in resource.")
            return
        }
        let jwtCreator = try JWTCreator(appID: "dummy", privateKey: privateKeyURL)
        let token = try jwtCreator.generate()

        guard let publicKeyURL = Bundle.module.url(forResource: "dummy", withExtension: "pub") else {
            XCTFail("Not found dummy.pub in resource.")
            return
        }
        let publicKey = try Data(contentsOf: publicKeyURL, options: .alwaysMapped)
        let signers = JWTSigners()
        let key = try RSAKey.public(pem: publicKey)
        signers.use(.rs256(key: key))
        let payload = try signers.verify(token.rawValue, as: JWTCreator.Payload.self)

        XCTAssertEqual(payload.issuer.value, "dummy")
    }
}
