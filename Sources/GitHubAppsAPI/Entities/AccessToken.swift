//
//  AccessToken.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation
import Tagged

public struct AccessToken: Decodable {
    // MARK: - Tagged
    public typealias Token = Tagged<Self, String>

    // MARK: - Properties
    public let token: Token
}
