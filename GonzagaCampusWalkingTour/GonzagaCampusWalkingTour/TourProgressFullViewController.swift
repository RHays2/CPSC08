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
    var stopsVisitedCount = 0
    @IBOutlet weak var tourName: UILabel!
    @IBOutlet weak var tourStatusLabel: UILabel!
    @IBOutlet weak var stopsVisitedLabel: UILabel!
    @IBOutlet weak var distanceTravelledLabel: UILabel!
    @IBOutlet weak var tourImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTourInformation()
        addTourProgressInformation()
    }
    
    func addTourInformation() {
        if let tour = self.selectedTour {
            print(tour.tourName)
            tourName.text = tour.tourName
            if let image = tour.previewImage {
                tourImage.image = image
            } else {
                let previewImage = UIImage(named: "default_preview_image")
                tourImage.image = previewImage
            }
            //add tour information from here
        }
    }
    
    func addTourProgressInformation() {
        if let progress = self.selectedTourProgress {
            //ryan, add progress information to the page from here
            if progress.tourCompleted == true {
                tourStatusLabel.text = "Completed on \(progress.dateCompleted)"
            }
            else {
                tourStatusLabel.text = "Incomplete"
            }
            for (_, val) in progress.stopProgress {
                if val == true {
                    stopsVisitedCount += 1
                }
            }
            if let tour = self.selectedTour {
               stopsVisitedLabel.text = "\(stopsVisitedCount) / \(Int(tour.tourLength))"
            }
            distanceTravelledLabel.text = "\(progress.distanceTraveled) miles"
        }
    }

}
