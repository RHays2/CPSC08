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
    @IBOutlet weak var caption: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the image to fill the screen
        imageView.image = image
        
        if let captionStr = captionString {
            caption.text = captionStr
        }
        else {
            caption.isHidden = true
        }
    }
}
