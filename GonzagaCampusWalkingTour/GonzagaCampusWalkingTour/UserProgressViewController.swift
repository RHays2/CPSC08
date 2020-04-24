//
//  UserProgressViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Ryan Hays on 4/19/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import UIKit

class UserProgressViewController: UIViewController {
    var databaseReference: DatabaseAccessible?
    var tourProgressRetriever: TourProgressRetrievable = UserDefaultsProgressRetrieval()
    var tourProgress: [String:TourProgress] = [:]
    var toursInfo: [TourInfo] = []
    @IBOutlet weak var distanceTravelledLabel: UILabel!
    var totalDistanceTravelled = 0.0
    @IBOutlet weak var toursCompletedLabel: UILabel!
    var totalToursCompleted = 0
    @IBOutlet weak var totalStopsVisitedLabel: UILabel!
    var totalStopsVisited = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTourInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpView() {
        sumDistanceTravelled()
        sumToursCompleted()
        sumStopsVisited()
        distanceTravelledLabel.text = "\(String(totalDistanceTravelled)) miles"
        toursCompletedLabel.text = "\(String(totalToursCompleted)) Tours"
        totalStopsVisitedLabel.text = "\(String(totalStopsVisited)) Stops"
    }
    
    func sumStopsVisited() {
        for key in self.tourProgress.keys {
            for (_, val) in tourProgress[key]!.stopProgress {
                if val == true {
                    totalStopsVisited += 1
                }
            }
        }
    }
    
    func sumToursCompleted() {
        for key in self.tourProgress.keys {
            if tourProgress[key]?.tourCompleted == true {
                totalToursCompleted += 1
            }
        }
    }
    
    func sumDistanceTravelled() {
        for key in self.tourProgress.keys {
            totalDistanceTravelled += tourProgress[key]!.distanceTraveled
        }
    }
    
    
    func getTourInfo() {
        if self.databaseReference != nil {
            let indicator = self.createCenteredProgressIndicator()
            self.view.addSubview(indicator)
            indicator.startAnimating()
            self.databaseReference?.getAllTourInfo(callback: {(tours) in
                self.toursInfo = tours
                self.getTourProgress()
                self.setUpView()
                indicator.stopAnimating()
            })
        }
    }
    
    func getTourProgress() {
        for tour in self.toursInfo {
            if let progress = self.tourProgressRetriever.getTourProgress(tourId: tour.id) {
                self.tourProgress[tour.id] = progress
            }
        }
    }
}
