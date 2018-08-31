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
}

class InspiroBotService {
    
    static let shared = InspiroBotService()
    
    private let api = InspiroBotAPI()
    
    private(set) var history: [Poster] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "inspirobot.history") else { return [] }
            return (try? JSONDecoder().decode([Poster].self, from: data)) ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.setValue(data, forKey: "inspirobot.history")
        }
    }
    
    func generatePoster(then completion: @escaping (Poster) -> Void) {
        api.generatePoster { result in
            switch result {
            case .success(let url):
                let poster = Poster(url: url)
                self.history.insert(poster, at: 0)
                completion(poster)
            case .failure:
                completion(Poster(url: URL(fileURLWithPath: "error.jpg")))
            }
        }
    }
    
}
