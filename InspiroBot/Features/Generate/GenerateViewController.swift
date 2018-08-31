//
//  GenerateViewController.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/30/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import UIKit

class GenerateViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var shareButton: UIBarButtonItem!
    @IBOutlet private var toggleFavoriteButton: UIBarButtonItem!
    
    private var poster: Poster?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let poster = poster else { return }
        toggleFavoriteButton.title = InspiroBotService.shared.isFavorite(poster) ? "Unfavorite" : "Favorite"
    }
    
    @IBAction private func generate() {
        imageView.image = nil
        shareButton.isEnabled = false
        toggleFavoriteButton.isEnabled = false
        toggleFavoriteButton.title = "Favorite"
        activityIndicator.startAnimating()
        InspiroBotService.shared.generatePoster { poster in
            self.poster = poster
            ImageLoader(url: poster.url).loadImage { image in
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
                self.shareButton.isEnabled = true
                self.toggleFavoriteButton.isEnabled = true
            }
        }
    }
    
    @IBAction private func share() {
        
    }
    
    @IBAction private func toggleFavorite(_ sender: UIBarButtonItem) {
        guard let poster = poster else { return }
        
        if InspiroBotService.shared.toggleFavorite(poster) {
            toggleFavoriteButton.title = "Unfavorite"
        } else {
            toggleFavoriteButton.title = "Favorite"
        }
    }

}
