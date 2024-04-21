//
//  RecipeProtocol.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 16/04/2024.
//

import Foundation
import Alamofire

protocol RecipeProtocol {
    var urlApi: String { get }
    func request(url: URL, completionHandler: @escaping (DataResponse<Any>) -> Void)
}
