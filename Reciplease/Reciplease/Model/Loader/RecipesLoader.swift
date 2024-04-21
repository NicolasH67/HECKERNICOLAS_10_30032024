//
//  RecipesLoader.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 16/04/2024.
//

import Foundation
import Alamofire

class RecipesLoader {
    static func fetchRecipes(ingrediants: [String], completion: @escaping (Result<RecipesResponses, Error>) -> Void) {
        let ingredientUrl = ingrediants.joined(separator: "+")
        let url = RecipesEndpoint.recipe(ingredientUrl).build()
        print(url)
            
        AF.request(url).responseData { response in
            switch response.result {
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
