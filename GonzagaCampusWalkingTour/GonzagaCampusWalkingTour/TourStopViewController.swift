//
//  TourStopViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Hays, Ryan T on 11/21/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class TourStopViewController: UIViewController {
    var currentStop: Stop?
    @IBOutlet weak var stopName: UILabel!
    @IBOutlet weak var stopDescription:UITextView!
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        setUpStopView()
    }
    
    func setUpStopView() {
        stopName.text = currentStop?.stopName
        stopDescription.text = currentStop?.stopDescription
    }
    
}
