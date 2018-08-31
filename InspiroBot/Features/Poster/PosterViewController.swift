//
//  PosterViewController.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/31/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var shareButton: UIBarButtonItem!
    @IBOutlet private var toggleFavoriteButton: UIBarButtonItem!
    
    private var poster: Poster!
    private var imageLoader: ImageLoader!
    
    static func make(with poster: Poster) -> PosterViewController {
        let storyboard = UIStoryboard(name: "PosterViewController", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! PosterViewController
        controller.poster = poster
        controller.imageLoader = ImageLoader(url: poster.url)
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLoader.loadImage { image in
            self.imageView.image = image
            self.shareButton.isEnabled = true
            self.toggleFavoriteButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        toggleFavoriteButton.title = InspiroBotService.shared.isFavorite(poster) ? "Unfavorite" : "Favorite"
    }
    
    @IBAction private func share() {
        guard let image = imageView.image else { return }
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true)
    }
    
    @IBAction private func toggleFavorite() {
        if InspiroBotService.shared.toggleFavorite(poster) {
            toggleFavoriteButton.title = "Unfavorite"
        } else {
            toggleFavoriteButton.title = "Favorite"
        }
    }

}
