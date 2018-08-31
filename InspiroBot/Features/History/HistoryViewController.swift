//
//  HistoryViewController.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/31/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import UIKit

class HistoryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InspiroBotService.shared.history.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.reuseIdentifier, for: indexPath) as! HistoryCell
        let poster = InspiroBotService.shared.history[indexPath.item]
        cell.configure(with: poster, isFavorite: InspiroBotService.shared.isFavorite(poster))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poster = InspiroBotService.shared.history[indexPath.item]
        let controller = PosterViewController.make(with: poster)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width)
    }

}

class HistoryCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HistoryCell"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var favoriteIcon: UIImageView!
    
    private var loader: ImageLoader?
    
    func configure(with poster: Poster, isFavorite: Bool) {
        favoriteIcon.isHidden = !isFavorite
        loader = ImageLoader(url: poster.url)
        loader?.loadImage { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loader?.cancel()
        favoriteIcon.isHidden = true
        imageView.image = nil
    }
    
}
