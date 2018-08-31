//
//  ImageLoader.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/30/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    
    private enum Status {
        case unloaded(URL)
        case loaded(UIImage)
    }
    
    private var status: Status
    private var task: URLSessionTask?
    
    init(url: URL) { status = .unloaded(url) }
    init(image: UIImage) { status = .loaded(image) }
    
    func loadImage(then completion: @escaping (UIImage) -> Void) {
        let _completion: (UIImage) -> Void = { image in
            self.status = .loaded(image)
            DispatchQueue.main.async { completion(image) }
        }
        
        switch status {
        case .loaded(let image):
            _completion(image)
        case .unloaded(let url):
            self.loadImage(from: url, then: _completion)
        }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
    }
    
    private func loadImage(from url: URL, then completion: @escaping (UIImage) -> Void) {
        if let image = ImageCache.shared.image(for: url) {
            completion(image)
            return
        }
        
        task?.cancel()
        task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image: UIImage
            defer { completion(image) }
            
            self?.task = nil
            
            if let data = data, let _image = UIImage(data: data) {
                ImageCache.shared.setImage(_image, for: url)
                image = _image
            } else {
                image = UIImage()
            }
        }
        task?.resume()
    }
    
}

private class ImageCache {
    
    static let shared = ImageCache()
    
    private struct CacheKey {
        let filename: String
        
        var filePath: String {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                .first!
                .appendingFormat("/%@", filename)
        }
        
        var raw: NSString { return filename as NSString }
        
        init(from url: URL) {
            filename = url.lastPathComponent
        }
    }
    
    private let cache = NSCache<NSString, UIImage>()
    
    func image(for url: URL) -> UIImage? {
        let key = CacheKey(from: url)
        if let image = cache.object(forKey: key.raw) {
            return image
        } else if let data = FileManager.default.contents(atPath: key.filePath), let image = UIImage(data: data) {
            cache.setObject(image, forKey: key.raw)
            return image
        }
        
        return nil
    }
    
    func setImage(_ image: UIImage, for url: URL) {
        let key = CacheKey(from: url)
        cache.setObject(image, forKey: key.raw)
        let fileURL = URL(fileURLWithPath: key.filePath)
        try? UIImageJPEGRepresentation(image, 1)?.write(to: fileURL, options: .withoutOverwriting)
    }
    
}
