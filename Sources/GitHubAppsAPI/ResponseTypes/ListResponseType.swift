//
//  ListResponseType.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public protocol ListResponseType: Decodable {
    associatedtype Element

    var items: [Element] { get }
}
