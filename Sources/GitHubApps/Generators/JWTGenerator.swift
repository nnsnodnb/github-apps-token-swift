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
    // MARK: - Properties
    public private(set) lazy var iat: Date = .init()
    public var exp: Date { return Date(timeInterval: 60 * 10, since: iat) }
    public let iss: String
    public let privateKey: Data

    // MARK: - Initialize
    public init(appID: String, privateKey: URL) throws {
        self.iss = appID
        self.privateKey = try Data(contentsOf: privateKey)
    }

    public func generate() throws -> Entities.JWT {
        let signers = JWTSigners()
        let key = try RSAKey.private(pem: privateKey)
        signers.use(.rs256(key: key))
        let payload = Payload(expiration: .init(value: exp), issuer: .init(value: iss))
        let token = try signers.sign(payload)
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

        public func verify(using signer: JWTKit.JWTSigner) throws {
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
