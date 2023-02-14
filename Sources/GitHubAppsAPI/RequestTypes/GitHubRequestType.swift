//
//  GitHubRequestType.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import APIKit
import Foundation

public protocol GitHubRequestType: Request {
    var endpoint: Endpoint { get }
}

public extension GitHubRequestType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    var path: String {
        return endpoint.rawValue
    }
    var dataParser: DataParser {
        return JSONParser()
    }
}

// MARK: - Base
public extension GitHubRequestType {
    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        urlRequest.timeoutInterval = 20
        return urlRequest
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200..<300:
            return object
        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200..<300:
            return object
        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }
}

// MARK: - Decodable
public extension GitHubRequestType where Response: Decodable {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else { throw ResponseError.unexpectedObject(object) }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}
