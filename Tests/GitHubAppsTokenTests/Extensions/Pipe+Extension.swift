//
//  Pipe+Extension.swift
//  
//
//  Created by Yuya Oka on 2023/02/16.
//

import Foundation

extension Pipe {
    func readStandardOutput() -> String? {
        guard let data = try? fileHandleForReading.readToEnd() else { return nil }
        return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .newlines)
    }
}
