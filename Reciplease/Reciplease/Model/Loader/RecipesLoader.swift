//
//  RecipesLoader.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 16/04/2024.
//

import Foundation
import Alamofire

protocol HttpClient {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class AlamofireHttpClient: HttpClient {
    func request(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).responseData{ result in
            guard let data = result.data, result.error == nil else {
                completion(.failure(NSError()))
                return
            }
            completion(.success(data))
        }
    }
}

class RecipesLoader {
    private let client: HttpClient
    
    init(client: HttpClient = AlamofireHttpClient()) {
        self.client = client
    }
    
    func fetchRecipes(ingredients: [String], from: Int, to: Int, completion: @escaping (Result<RecipesResponses, Error>) -> Void) {
        let ingredientUrl = ingredients.joined(separator: "+")
        let url = RecipesEndpoint.recipe(text: ingredientUrl, from: from, to: to).build()
        
        client.request(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let recipesResponse = try JSONDecoder().decode(RecipesResponses.self, from: data)
                    completion(.success(recipesResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
