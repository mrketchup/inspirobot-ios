//
//  GenerateViewController.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/30/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import UIKit

class GenerateViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func generate() {
        self.imageView.image = nil
        activityIndicator.startAnimating()
        InspiroBotService.shared.generatePoster { poster in
            ImageLoader(url: poster.url).loadImage { image in
                self.activityIndicator.stopAnimating()
                self.imageView.image = image
            }
        }
    }

}
