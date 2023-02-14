//
//  Permission.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public struct Permission: Encodable {
    // MARK: - Properties
    public let contents: Level?
    public let statuses: Level?
    public let pullRequests: Level?
    public let issues: Level?
    public let metadata: Level?

    public var jsonObject: [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return jsonObject ?? [:]
        } catch {
            return [:]
        }
    }

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case contents
        case statuses
        case pullRequests = "pull_requests"
        case issues
        case metadata
    }

    // MARK: - Initialize
    public init(
        contents: Level? = nil,
        statuses: Level? = nil,
        pullRequests: Level? = nil,
        issues: Level? = nil
    ) {
        self.contents = contents
        self.statuses = statuses
        self.pullRequests = pullRequests
        self.issues = issues
        self.metadata = contents == nil && statuses == nil && pullRequests == nil && issues == nil ? nil : .read
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(contents, forKey: .contents)
        try container.encodeIfPresent(statuses, forKey: .statuses)
        try container.encodeIfPresent(pullRequests, forKey: .pullRequests)
        try container.encodeIfPresent(issues, forKey: .issues)
        try container.encodeIfPresent(metadata, forKey: .metadata)
    }
}

// MARK: - Level
public extension Permission {
    enum Level: String, Encodable {
        case read
        case write
    }
}
