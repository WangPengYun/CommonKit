//
//  HttpClient.swift
//  CommomKit
//
//  Created by wangpengyun on 2025/10/22.
//

import Foundation

public protocol HttpClient {
    func get(url: URL) async throws -> (Data, URLResponse)
}

public final class URLSessionClient: HttpClient {
    private let session: URLSession
    
    public init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    public func get(url: URL) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await session.data(from: url)
            return (data, response)
        } catch {
            throw error
        }
    }
}

public extension URLSessionConfiguration {
    static func lowPowerMode() -> URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.allowsExpensiveNetworkAccess = false
        config.allowsConstrainedNetworkAccess = true
        config.httpMaximumConnectionsPerHost = 3
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        return config
    }
}
