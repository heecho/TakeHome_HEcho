//
//  MockURLSession.swift
//  FetchRecipes_HEcho
//
//  Created by Hannah Echo on 3/2/25.
//

import Foundation
import UIKit
@testable import FetchRecipes_HEcho

class MockURLSession: URLSessionProtocol, @unchecked Sendable {
    var mockData: Data?
    var mockError: Error?
    
    init(mockData: Data? = nil, mockError: Error? = nil) {
        self.mockData = mockData
        self.mockError = mockError
    }

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw URLError(.badServerResponse)
        }
        
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data, response)
    }
        
    func decode<T: Decodable>(_ type: T.Type, from url: URL, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) async throws -> T {
        guard let data = mockData else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIClientError.decodingFailed
        }
    }
}
