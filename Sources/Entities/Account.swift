//
//  Account.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation
import Tagged

public struct Account: Decodable, Equatable, Sendable {
    // MARK: - Tagged
    public typealias ID = Tagged<Self, Int>

    // MARK: - Properties
    public let id: ID
    public let login: String
    public let avatarURL: URL
    public let organizationsURL: URL

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case organizationsURL = "organizations_url"
    }
}
