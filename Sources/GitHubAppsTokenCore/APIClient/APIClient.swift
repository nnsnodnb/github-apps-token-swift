//
//  APIClient.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation
#if os(Linux) && canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Get
import GitHubAppsAPI

public final class APIClient: APIClientProtocol {
    // MARK: - Properties
    private let apiClient: Get.APIClient

    // MARK: - Initialize
    public init(baseURL: Foundation.URL?, proxyURL: Foundation.URL? = nil) {
        let sessionConfiguration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            if let proxyURL {
                #if os(Linux)
                var connectionProxyDictionary: [AnyHashable: Any] = [
                    "HTTPEnable": 1,
                    "HTTPSEnable": 1
                ]
                connectionProxyDictionary["HTTPProxy"] = proxyURL.host
                connectionProxyDictionary["HTTPPort"] = proxyURL.port
                connectionProxyDictionary["HTTPSProxy"] = proxyURL.host
                connectionProxyDictionary["HTTPSPort"] = proxyURL.port
                configuration.connectionProxyDictionary = connectionProxyDictionary
                #else
                configuration.connectionProxyDictionary = [
                    kCFNetworkProxiesHTTPEnable: 1,
                    kCFNetworkProxiesHTTPProxy: proxyURL.host,
                    kCFNetworkProxiesHTTPPort: proxyURL.port,
                    kCFNetworkProxiesHTTPSEnable: 1,
                    kCFNetworkProxiesHTTPSProxy: proxyURL.host,
                    kCFNetworkProxiesHTTPSPort: proxyURL.port
                ].compactMapValues { $0 }
                #endif
            }
            return configuration
        }()
        let configuration = Get.APIClient.Configuration(baseURL: baseURL, sessionConfiguration: sessionConfiguration)
        self.apiClient = .init(configuration: configuration)
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
