//
//  FullImageViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 11/30/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    var image:UIImage?
    var captionString:String?
    @IBOutlet weak var imageView:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the image to fill the screen
        imageView.image = image
    }
}
