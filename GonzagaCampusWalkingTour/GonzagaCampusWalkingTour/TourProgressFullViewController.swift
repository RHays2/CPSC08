//
//  TourProgressFullViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/23/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import UIKit

class TourProgressFullViewController: UIViewController {
    var selectedTourProgress: TourProgress?
    var selectedTour: TourInfo?

    @IBOutlet weak var tourName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTourInformation()
        addTourProgressInformation()
    }
    
    func addTourInformation() {
        if let tour = self.selectedTour {
            print(tour.tourName)
            tourName.text = tour.tourName
            //add tour information from here
        }
    }
    
    func addTourProgressInformation() {
        if let progress = self.selectedTourProgress {
            //ryan, add progress information to the page from here
        }
    }

}
