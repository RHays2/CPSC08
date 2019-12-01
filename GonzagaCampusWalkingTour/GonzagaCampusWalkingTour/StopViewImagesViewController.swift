//
//  StopViewImagesViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 11/26/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class StopViewImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var curStop:Stop?
    var assets:[Asset] = []
    let reuseIdentifier = "imageView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tempAssets = curStop?.stopAssets {
            assets = tempAssets
        }
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let stopCell = cell as? StopCollectionViewCell else {
            return cell
        }
        stopCell.image.image = assets[indexPath.item].asset
        return stopCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = (collectionView.frame.width - 30) / 3
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name:"Main", bundle:nil)
        if let fullImageView = storyBoard.instantiateViewController(withIdentifier: "FullImageViewController") as? FullImageViewController {
            fullImageView.image = assets[indexPath.item].asset
            navigationController?.pushViewController(fullImageView, animated: true)
        }
    }
}
