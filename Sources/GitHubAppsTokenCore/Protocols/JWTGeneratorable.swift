//
//  JWTGeneratorable.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Entities
import Foundation

public protocol JWTGeneratorable {
    var iat: Date { get }
    var exp: Date { get }
    var iss: String { get }
    var privateKey: Data { get }

    func generate() throws -> JWT
}
