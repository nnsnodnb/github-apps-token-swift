//
//  CommandType.swift
//  
//
//  Created by Yuya Oka on 2023/02/15.
//

import Foundation

enum CommandType: String, CaseIterable {
    case create
    case revoke
}

// MARK: - Error
extension CommandType {
    enum Error: Swift.Error, CustomStringConvertible {
        case unknown

        var description: String {
            switch self {
            case .unknown:
                return "不明なコマンドが入力されました"
            }
        }
    }
}
