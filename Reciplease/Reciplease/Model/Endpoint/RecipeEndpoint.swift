//
//  RecipeRouter.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 09/04/2024.
//

import Foundation
import Alamofire

enum RecipeEndPoint {
    case recipe(String, String)
    
    func build() -> URL {
        var components = URLComponents()
                
        components.scheme = "https"
        components.host = "api.edamam.com"
        components.path = "search?"
        switch self {
        case let .recipe(target, text):
            components.queryItems = [
                URLQueryItem(name: "app_id", value: "ea6735b6"),
                URLQueryItem(name: "app_key", value: "6ce491955b23257edb5c4a14ec8ca045"),
                URLQueryItem(name: "mineType", value: "text/Plain"),
                URLQueryItem(name: "q", value: text),
            ]
        }
        return components.url!
    }
}
