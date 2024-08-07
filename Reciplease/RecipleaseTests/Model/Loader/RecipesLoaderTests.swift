//
//  RecipesLoaderTests.swift
//  RecipleaseTests
//
//  Created by Nicolas Hecker on 17/07/2024.
//

import XCTest
@testable import Reciplease

class MockHttpClient: HttpClient {
    var result: Result<Data, Error>?
    
    init(result: Result<Data, Error>? = nil) {
        self.result = result
    }
    
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let result = result {
            completion(result)
        }
    }
}

final class RecipesLoaderTests: XCTestCase {
    func testFetchRecipesSuccess() {
        let mockClient = MockHttpClient()
        let loader = RecipesLoader(client: mockClient)
        
        mockClient.result = .success(anyData())
        
        let expectation = self.expectation(description: "Completion called")
        
        loader.fetchRecipes(ingredients: ["label"], from: 0, to: 10) { result in
            switch result {
            case .success(let recipesResponse):
                let recipe = recipesResponse.hits.first?.recipe
                XCTAssertEqual(recipesResponse.q, "label")
                XCTAssertEqual(recipe?.label, "recipelabel")
                XCTAssertEqual(recipe?.calories, 3000)
                XCTAssertEqual(recipe?.totalTime, 60)
                XCTAssertEqual(recipe?.ingredients.first?.text, "ingredientsLabel")
                XCTAssertEqual(recipe?.shareAs, "http://www.urlTest.com")
                XCTAssertEqual(recipe?.image, "http://www.urlTest.com")
            case .failure(let error):
                XCTFail("Expected success but got failure with \(error)")
            }
        expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchRecipesFail() {
        let mockClient = MockHttpClient()
        let loader = RecipesLoader(client: mockClient)

        mockClient.result = .failure(NSError(domain: "Test", code: 0, userInfo: nil))
        
        let expectation = self.expectation(description: "Completion called")
        
        loader.fetchRecipes(ingredients: ["label"], from: 0, to: 10) { result in
            switch result {
            case .success(let recipes):
                XCTFail("Expected failure but got success with \(recipes)")
            default :
                break
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchRecipesNoData() {
        let mockClient = MockHttpClient()
        let loader = RecipesLoader(client: mockClient)
        
        mockClient.result = .success(noData())
        
        let expectation = self.expectation(description: "Completion called")
        
        loader.fetchRecipes(ingredients: ["label"], from: 0, to: 10) { result in
            switch result {
            case .success(let recipesResponse):
                XCTAssertTrue(recipesResponse.hits.isEmpty, "Expected no recipes but got some")
            case .failure(let error):
                XCTFail("Expected success but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchRecipesInvalidData() {
        let mockClient = MockHttpClient()
        let loader = RecipesLoader(client: mockClient)

        mockClient.result = .success(invalidDate())
        
        let expectation = self.expectation(description: "Completion called")
        
        loader.fetchRecipes(ingredients: ["label"], from: 0, to: 10) { result in
            switch result {
            case .success(let recipesResponse):
                XCTFail("Expected failure but got success with \(recipesResponse)")
            case .failure(let error):
                XCTAssertNotNil(error, "Expected an error but got nil")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func anyData() -> Data {
        let jsonString = """
        {
            "q": "label",
            "from": 0,
            "to": 10,
            "more": true,
            "count": 1,
            "hits": [
                {
                    "recipe": {
                        "label": "recipelabel",
                        "image": "http://www.urlTest.com",
                        "shareAs": "http://www.urlTest.com",
                        "ingredients": [
                            {
                                "text": "ingredientsLabel",
                                "quantity": 0.5,
                                "measure": "cup",
                                "food": "olive oil",
                                "weight": 108,
                                "foodCategory": "Oils",
                                "foodId": "food_b1d1icuad3iktrbqby0hiagafaz7",
                                "image": "https://www.edamam.com/food-img/abcd/abcd123.jpg"
                            }
                        ],
                        "calories": 3000,
                        "totalTime": 60,
                    }
                }
            ],
        }
        """
        return jsonString.data(using: .utf8)!
    }
    
    func invalidDate() -> Data {
        let jsonString = """
            {
                "q": "label",
                "from": 0,
                "to": 10,
                "more": true,
                "count": 1,
                "hits": ["invalid_data"]
            }
        """
        return jsonString.data(using: .utf8)!
    }
    
    func noData() -> Data {
        let jsonString = """
            {
                "q": "label",
                "from": 0,
                "to": 10,
                "more": true,
                "count": 1,
                "hits": []
            }
        """
        return jsonString.data(using: .utf8)!
    }
}
