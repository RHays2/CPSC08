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
    var assets:[Asset]?
    let reuseIdentifier = "imageView"
    var databaseReference: DatabaseAccessible?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tempAssets = curStop?.stopAssets {
            assets = tempAssets
        }
        collectionView.delegate = self
        
        //make sure that the stop hasnt already loaded the assets
        if self.curStop?.stopAssets == nil {
           loadImages()
        }
        else {
            //we have already loaded the assets
            //dont waste time and load again
            self.getLocalImages()
            self.assets = self.curStop?.stopAssets
            self.collectionView.reloadData()
        }
        
    }
    
    func loadImages() {
        if self.databaseReference != nil && self.curStop != nil {
            let indicator = self.createCenteredProgressIndicator()
            indicator.startAnimating()
            self.view.addSubview(indicator)
            self.databaseReference?.getStopAssets(stopId: self.curStop!.id, callback: {(assets) in
                self.assets = assets
                self.curStop?.stopAssets = assets
                indicator.stopAnimating()
                self.collectionView.reloadData()
            })
        }
    }
    
    
    func getLocalImages() {
        if let assets = self.assets{
            for asset in assets {
                if let url = asset.assetURL {
                    if let image = FileManager.default.getImageFromPath(urlStr: url) {
                        asset.asset = image
                    }
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = assets?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        guard let stopCell = cell as? StopCollectionViewCell else {
            return cell
        }
        if let image = assets?[indexPath.item].asset {
            stopCell.image.image = image
        }
        else {
            stopCell.image.image = UIImage(named: "default_preview_image")
        }
        
        return stopCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideLength = (collectionView.frame.width - 30) / 3
        return CGSize(width: sideLength, height: sideLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name:"Main", bundle:nil)
        if let fullImageView = storyBoard.instantiateViewController(withIdentifier: "FullImageViewController") as? FullImageViewController {
            if let image = assets?[indexPath.item].asset, let caption = assets?[indexPath.item].assetDescription {
                fullImageView.image = image
                fullImageView.captionString = caption
            }
            else {
                fullImageView.image = UIImage(named: "default_preview_image")
            }
            
            navigationController?.pushViewController(fullImageView, animated: true)
        }
    }
}
