//
//  File.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 09/04/2024.
//

import Foundation
import Alamofire

class RecipeLoader {
    func fetchRecipes(endpoint: RecipeEndpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = endpoint.build()
        
        AF.request(request).response { response in
            switch response.result {
            case .success(let value):
                guard let data = value as? [String: Any], let jsonData = data["data"] as? [String: Any] else {
                    print("Invalid JSON format")
                    return
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
