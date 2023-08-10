//
//  StubAPIClient.swift
//  
//
//  Created by Yuya Oka on 2023/08/10.
//

import Foundation
import GitHubAppsAPI

final class StubAPIClient: APIClientProtocol {
    // MARK: - Properties
    let responseDecodable: Decodable

    // MARK: - Initialize
    init(responseDecodable: Decodable) {
        self.responseDecodable = responseDecodable
    }

    func response<R: RequestType>(for request: R) async throws -> R.Response where R.Response: Decodable {
        return responseDecodable as! R.Response
    }

    func response<R: RequestType>(for request: R) async throws where R.Response == Void {
    }
}
