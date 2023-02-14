//
//  Installation.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation
import Tagged

public struct Installation: Decodable {
    // MARK: - Tagged
    public typealias ID = Tagged<Self, Int>

    // MARK: - Properties
    public let id: ID
    public let account: Account
    public let repositorySelection: String

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        case account
        case repositorySelection = "repository_selection"
    }
}
