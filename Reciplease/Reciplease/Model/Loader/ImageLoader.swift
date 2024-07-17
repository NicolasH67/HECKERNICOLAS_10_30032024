//
//  ImageLoader.swift
//  Reciplease
//
//  Created by Nicolas Hecker on 26/04/2024.
//

import Foundation
import Alamofire

// Define the protocol for the image downloader
protocol ImageDownloader {
    func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

// Implement the Alamofire-based image downloader
class AlamofireImageDownloader: ImageDownloader {
    func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// Example usage class for image downloading
class ImageLoader {
    private let downloader: ImageDownloader
    
    init(downloader: ImageDownloader = AlamofireImageDownloader()) {
        self.downloader = downloader
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        downloader.downloadImage(from: url) { result in
            completion(result)
        }
    }
}

