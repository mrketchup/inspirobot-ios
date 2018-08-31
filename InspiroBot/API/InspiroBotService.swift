//
//  InspiroBotService.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/30/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import Foundation
import UIKit

struct Poster: Codable, Hashable {
    let url: URL
}

class InspiroBotService {
    
    static let shared = InspiroBotService()
    
    private let api = InspiroBotAPI()
    
    private var _history: [Poster]?
    private(set) var history: [Poster] {
        get {
            if let history = _history { return history }
            guard let data = UserDefaults.standard.data(forKey: "inspirobot.history") else { return [] }
            _history = try? JSONDecoder().decode([Poster].self, from: data)
            return _history ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.setValue(data, forKey: "inspirobot.history")
            _history = nil
        }
    }
    
    private var _favorites: [Poster]?
    private(set) var favorites: [Poster] {
        get {
            if let favorites = _favorites { return favorites }
            guard let data = UserDefaults.standard.data(forKey: "inspirobot.favorites") else { return [] }
            _favorites = try? JSONDecoder().decode([Poster].self, from: data)
            return _favorites ?? []
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.setValue(data, forKey: "inspirobot.favorites")
            _favorites = nil
        }
    }
    
    private var favoriteLookupCache: [Poster: Bool] = [:]
    
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
    
    func isFavorite(_ poster: Poster) -> Bool {
        let isFavorite = favoriteLookupCache[poster] ?? favorites.contains(poster)
        favoriteLookupCache[poster] = isFavorite
        return isFavorite
    }
    
    @discardableResult
    func toggleFavorite(_ poster: Poster) -> Bool {
        favoriteLookupCache[poster] = nil
        if let index = favorites.index(of: poster) {
            favorites.remove(at: index)
            return false
        } else {
            favorites.insert(poster, at: 0)
            return true
        }
    }
    
}
