//
//  RecipesEndpoint.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 16/04/2024.
//

import Foundation

enum RecipesEndpoint {
    case recipe(String)
        
    func build() -> URL {
        let baseURLString = "https://api.edamam.com/search"
        
        var components = URLComponents(string: baseURLString)!
        var parameters: [URLQueryItem] = []
        
        switch self {
        case let .recipe(text):
            parameters.append(URLQueryItem(name: "app_id", value: Config.appID))
            parameters.append(URLQueryItem(name: "app_key", value: Config.appKey))
            parameters.append(URLQueryItem(name: "mineType", value: "text/Plain"))
            parameters.append(URLQueryItem(name: "q", value: text))
        }
        
        components.queryItems = parameters
        
        guard let url = components.url else {
            fatalError("Could not construct URL")
        }
        
        return url
    }
}
