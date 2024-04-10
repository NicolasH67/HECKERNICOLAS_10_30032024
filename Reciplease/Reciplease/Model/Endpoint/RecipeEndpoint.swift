//
//  RecipeRouter.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 09/04/2024.
//

import Foundation
import Alamofire

enum RecipeEndpoint {
    case recipe(String)
    
    func build() -> URLRequest {
        let baseURLString = "https://api.edamam.com/search"
        
        var parameters: [String: String] = [:]
        
        switch self {
        case let .recipe(text):
            parameters["app_id"] = Config.appID
            parameters["app_key"] = Config.appKey
            parameters["mineType"] = "text/Plain"
            parameters["q"] = text
        }
        
        let url = URL(string: baseURLString)!
        
        return try! URLEncoding.queryString.encode(URLRequest(url: url, method: .get), with: parameters)
    }
}
