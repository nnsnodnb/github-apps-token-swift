//
//  JWTGenerator.swift
//
//
//  Created by Yuya Oka on 2023/02/15.
//

import Entities
import Foundation
import JWTKit

public final class JWTGenerator: JWTGeneratorable {
  // MARK: - Error
  public enum Error: Swift.Error {
    case invalidPrivateKeyEncoding
  }

  // MARK: - Properties
  public private(set) lazy var iat: Date = .init()
  public var exp: Date { return Date(timeInterval: 60 * 10, since: iat) }
  public let iss: String
  private let keys: JWTKeyCollection

  // MARK: - Initialize
  public init(appID: String, privateKey: URL) async throws {
    self.iss = appID
    let data = try Data(contentsOf: privateKey)
    guard let privateKey = String(data: data, encoding: .utf8) else {
      throw Error.invalidPrivateKeyEncoding
    }
    let keys = JWTKeyCollection()
    let rsaKey = try JWTKit.Insecure.RSA.PrivateKey(pem: privateKey)
    await keys.add(rsa: rsaKey, digestAlgorithm: .sha256)
    self.keys = keys
  }

  public func generate() async throws -> Entities.JWT {
    let payload = Payload(expiration: .init(value: exp), issuer: .init(value: iss))
    let token = try await keys.sign(payload)
    return .init(token)
  }
}

// MARK: - Paylaod
public extension JWTGenerator {
  struct Payload: JWTPayload {
    let issuedAt: IssuedAtClaim = .init(value: .init())
    let expiration: ExpirationClaim
    let issuer: IssuerClaim

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
      case issuedAt = "iat"
      case expiration = "exp"
      case issuer = "iss"
    }

    public func verify(using algorithm: some JWTAlgorithm) async throws {
      try self.expiration.verifyNotExpired()
    }

    public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      let issuedAt = Int(issuedAt.value.timeIntervalSince1970)
      try container.encode(issuedAt, forKey: .issuedAt)
      let expiration = Int(expiration.value.timeIntervalSince1970)
      try container.encode(expiration, forKey: .expiration)
      try container.encode(issuer, forKey: .issuer)
    }
  }
}
