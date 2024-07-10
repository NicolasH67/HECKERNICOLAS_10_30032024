//
//  RecipeTest.swift
//  RecipleaseTests
//
//  Created by Nicolas Hecker on 10/07/2024.
//

import XCTest
@testable import Reciplease

class MockRecipeURLProtocol: URLProtocol {
    static var mockResponseData: Data?
    static var mockError: Error?
    static var mockResponse: HTTPURLResponse?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {
        if let data = MockRecipeURLProtocol.mockResponseData {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let error = MockRecipeURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        if let response = MockRecipeURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    static func resetMock() {
        MockRecipeURLProtocol.mockError = nil
        MockRecipeURLProtocol.mockResponse = nil
        MockRecipeURLProtocol.mockResponseData = nil
    }
}

final class RecipeTest: XCTestCase {
    
}
