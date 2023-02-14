//
//  APIClient.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Foundation

public final class APIClient {
    // MARK: - Properties
    private let session: Session

    // MARK: - Initialize
    public init(session: Session = .shared) {
        self.session = session
    }

    func response<Request: GitHubRequestType>(
        for request: Request,
        callbackQueue: CallbackQueue? = nil
    ) async throws -> Request.Response {
        return try await session.response(for: request, callbackQueue: callbackQueue)
    }
}
