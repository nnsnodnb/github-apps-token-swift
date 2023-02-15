//
//  JWTCreator.swift
//  
//
//  Created by Yuya Oka on 2023/02/15.
//

import Entities
import Foundation
import SwiftJWT

public final class JWTCreator: JWTCreatable {
    // MARK: - Properties
    public private(set) lazy var iat: Date = .init()
    public var exp: Date { return Date(timeInterval: 60 * 10, since: iat) }
    public let iss: String
    public let privateKey: String

    // MARK: - Initialize
    public init(appID: String, privateKey: URL) throws {
        self.iss = appID
        self.privateKey = try String(contentsOf: privateKey)
    }

    public func generate() throws -> Entities.JWT {
        let header = Header(typ: "JWT")
        let payload = Payload(iat: iat, exp: exp, iss: iss)
        var jwt = JWT(header: header, claims: payload)
        let privateKeyData = privateKey.data(using: .utf8)
        let signer = JWTSigner.rs256(privateKey: privateKeyData ?? .init())
        let token = try jwt.sign(using: signer)
        return .init(token)
    }
}

// MARK: - Paylaod
private extension JWTCreator {
    struct Payload: Claims {
        let iat: Date
        let exp: Date
        let iss: String

        func encode() throws -> String {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .custom { date, encoder in
                var container = encoder.singleValueContainer()
                try container.encode(Int(date.timeIntervalSince1970))
            }
            let data = try encoder.encode(self)
            return JWTEncoder.base64urlEncodedString(data: data)
        }
    }
}
