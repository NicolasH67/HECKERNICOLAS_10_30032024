//
//  ImageLoader.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 26/04/2024.
//

import Foundation
import Alamofire

class ImageLoader {
    static func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Image download failed: \(error)")
                completion(nil)
            }
        }
    }
}

