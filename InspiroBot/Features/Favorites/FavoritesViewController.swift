//
//  FavoritesViewController.swift
//  InspiroBot
//
//  Created by Matt Jones on 8/31/18.
//  Copyright © 2018 Matt Jones. All rights reserved.
//

import UIKit

class FavoritesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return InspiroBotService.shared.favorites.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseIdentifier, for: indexPath) as! FavoriteCell
        cell.configure(with: InspiroBotService.shared.favorites[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let poster = InspiroBotService.shared.favorites[indexPath.item]
        let controller = PosterViewController.make(with: poster)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width)
    }

}

class FavoriteCell: UICollectionViewCell {
    
    static let reuseIdentifier = "FavoriteCell"
    
    @IBOutlet var imageView: UIImageView!
    
    private var loader: ImageLoader?
    
    func configure(with poster: Poster) {
        loader = ImageLoader(url: poster.url)
        loader?.loadImage { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loader?.cancel()
        imageView.image = nil
    }
    
}
