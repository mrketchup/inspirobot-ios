//
//  InspiroBotService.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/30/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import Foundation
import UIKit

struct Poster: Codable {
    let url: URL
    let imageLoader: ImageLoader
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let url = try values.decode(URL.self, forKey: .url)
        self.init(url: url)
    }
    
    init(url: URL) {
        self.url = url
        imageLoader = ImageLoader(url: url)
    }
    
    init (image: UIImage) {
        self.url = URL(fileURLWithPath: "unknown.jpg")
        imageLoader = ImageLoader(image: image)
    }
}

class InspiroBotService {
    
    static let shared = InspiroBotService()
    
    private let api = InspiroBotAPI()
    
    func generatePoster(then completion: @escaping (Poster) -> Void) {
        api.generatePoster { result in
            switch result {
            case .success(let url):
                let poster = Poster(url: url)
                completion(poster)
            case .failure: completion(Poster(image: UIImage()))
            }
        }
    }
    
}
