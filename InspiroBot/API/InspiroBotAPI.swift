//
//  InspiroBotAPI.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/30/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import Foundation

class InspiroBotAPI {
    
    enum Error: Swift.Error {
        case unknown
        case network(Swift.Error)
    }
    
    enum Result {
        case success(URL)
        case failure(Error)
    }
    
    func generatePoster(then completion: @escaping (Result) -> Void) {
        let url = URL(string: "http://inspirobot.me/api?generate=true")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            let result: Result
            defer {
                DispatchQueue.main.async { completion(result) }
            }
            
            if let error = error {
                result = .failure(.network(error))
            } else if let data = data {
                result = self.process(data)
            } else {
                result = .failure(.unknown)
            }
        }
        task.resume()
    }
    
    private func process(_ data: Data) -> Result {
        guard let urlString = String(data: data, encoding: .utf8), let url = URL(string: urlString) else {
            return .failure(.unknown)
        }
        
        return .success(url)
    }
    
}
