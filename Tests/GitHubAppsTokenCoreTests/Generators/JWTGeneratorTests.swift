//
//  JWTGeneratorTests.swift
//
//
//  Created by Yuya Oka on 2023/02/16.
//

import Foundation
@testable import GitHubAppsTokenCore
import JWTKit
import Testing

struct JWTGeneratorTests {
  @Test
  func testGenerate() async throws {
    guard let privateKeyURL = Bundle.module.url(forResource: "dummy", withExtension: "pem") else {
      Issue.record("Not found dummy.pem in resource.")
      return
    }
    let jwtGenerator = try await JWTGenerator(appID: "dummy", privateKey: privateKeyURL)
    let token = try await jwtGenerator.generate()

    guard let publicKeyURL = Bundle.module.url(forResource: "dummy", withExtension: "pub") else {
      Issue.record("Not found dummy.pub in resource.")
      return
    }
    let data = try Data(contentsOf: publicKeyURL, options: .alwaysMapped)
    let publicKey = try Insecure.RSA.PublicKey(pem: String(data: data, encoding: .utf8)!)
    let keys = JWTKeyCollection()
    await keys.add(rsa: publicKey, digestAlgorithm: .sha256)

    let payload = try await keys.verify(token.rawValue, as: JWTGenerator.Payload.self)

    #expect(payload.issuer.value == "dummy")
  }
}
