//
//  PermissionType.swift
//  
//
//  Created by Yuya Oka on 2023/02/15.
//

import Foundation

enum PermissionType: String, Decodable {
    case contents
    case statuses
    case pullRequests = "pull_requests"
    case issues
}

// MARK: - Error
extension PermissionType {
    enum Error: Swift.Error, CustomStringConvertible {
        case unknown

        var description: String {
            switch self {
            case .unknown:
                return "不明な権限です"
            }
        }
    }
}
