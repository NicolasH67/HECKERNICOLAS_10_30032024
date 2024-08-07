//
//  ImageLoaderTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Hecker on 17/07/2024.
//

import XCTest
@testable import Reciplease

class MockImageDownloader: ImageDownloader {
    private let result: Result<Data, Error>
    
    init(result: Result<Data, Error>) {
        self.result = result
    }
    
    func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        completion(result)
    }
}

final class ImageLoaderTests: XCTestCase {
    func testImageLoaderSuccess() {
        let expectedData = "Test Image Data".data(using: .utf8)!
        let mockDownloader = MockImageDownloader(result: .success(expectedData))
        let imageLoader = ImageLoader(downloader: mockDownloader)
        let imageUrl = URL(string: "https://example.com/image.jpg")!
        
        let expectation = self.expectation(description: "Image download should succeed")
        
        imageLoader.fetchImage(from: imageUrl) { result in
            if case .success(let data) = result {
                XCTAssertEqual(data, expectedData)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
    
    func testImageLoaderFailure() {
        let expectedError = NSError(domain: "test", code: 0, userInfo: nil)
        let mockDownloader = MockImageDownloader(result: .failure(expectedError))
        let imageLoader = ImageLoader(downloader: mockDownloader)
        let imageUrl = URL(string: "https://example.com/image.jpg")!
        
        let expectation = self.expectation(description: "Image download should fail")
        imageLoader.fetchImage(from: imageUrl) { result in
            if case .success = result {
                XCTFail("Expected failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
