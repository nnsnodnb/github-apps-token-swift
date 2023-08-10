//
//  APIClient.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation
import Get
import GitHubAppsAPI

public final class APIClient: APIClientProtocol {
    // MARK: - Properties
    private let apiClient: Get.APIClient

    // MARK: - Initialize
    public init(baseURL: URL?) {
        self.apiClient = .init(baseURL: baseURL)
    }

    public func response<R: RequestType>(for request: R) async throws -> R.Response where R.Response: Decodable {
        let request = request.buildRequest()
        let response = try await apiClient.send(request, configure: { $0.timeoutInterval = 20 })
        return response.value
    }

    public func response<R: RequestType>(for request: R) async throws where R.Response == Void {
        let request = request.buildRequest()
        try await apiClient.send(request, configure: { $0.timeoutInterval = 20 })
    }
}
