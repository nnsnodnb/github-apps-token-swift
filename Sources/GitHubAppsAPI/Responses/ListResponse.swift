//
//  ListResponse.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public struct ListResponse<Element: Decodable>: ListResponseType, Decodable {
    // MARK: - Properties
    public let items: [Element]
}
