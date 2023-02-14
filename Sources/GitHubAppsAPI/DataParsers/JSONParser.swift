//
//  JSONParser.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Foundation

public struct JSONParser: DataParser {
    // MARK: - Properties
    public let contentType: String? = "application/json"

    public func parse(data: Data) throws -> Any {
        return data
    }
}
