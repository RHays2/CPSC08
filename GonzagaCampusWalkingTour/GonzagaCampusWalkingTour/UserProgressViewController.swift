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
        print("VIEWWILLAPPEAR")
    }
    
    func setUpView() {
        sumDistanceTravelled()
        sumToursCompleted()
        sumStopsVisited()
        //print(tourProgress)
        //distanceTravelledLabel.text = "10 Miles"
        distanceTravelledLabel.text = "\(String(totalDistanceTravelled)) miles"
        toursCompletedLabel.text = "\(String(totalToursCompleted)) Tours"
        totalStopsVisitedLabel.text = "\(String(totalStopsVisited)) Stops"
    }
    
    func sumStopsVisited() {
        for key in self.tourProgress.keys {
            print("id: \(tourProgress[key]?.id ?? "") \nstop progress: \(tourProgress[key]?.stopProgress)\n")
            for (_, val) in tourProgress[key]!.stopProgress {
                if val == true {
                    totalStopsVisited += 1
                }
            }
        }
    }
    
    func sumToursCompleted() {
        print("START SUMSTOPSVISITED")
        for key in self.tourProgress.keys {
            //print("id: \(tourProgress[key]?.id ?? "") \nstop progress: \(tourProgress[key]?.stopProgress)\n")
            if tourProgress[key]?.tourCompleted == true {
                totalToursCompleted += 1
            }
            //print(tourProgress[key]?.tourCompleted)
        }
    }
    
    func sumDistanceTravelled() {
        for key in self.tourProgress.keys {
            print("id: \(tourProgress[key]?.id ?? "") \ndistance travelled: \(tourProgress[key]?.distanceTraveled)\n")
            print(tourProgress[key]!.distanceTraveled + 1.0)
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
                
                /*
                print("PRINTING TOUR INFO")
                for tour in tours {
                    print("name: \(tour.tourName) \nid: \(tour.id)\n")
                    //self.tourProgressDict[tour.tourName] = tour.id
                }
 
                */
                //print(self.tourProgressDict)
                //self.tableView.reloadData() *******************************
                indicator.stopAnimating()
            })
        }
        print("END GETTOURINFO")
    }
    
    func getTourProgress() {
        for tour in self.toursInfo {
            if let progress = self.tourProgressRetriever.getTourProgress(tourId: tour.id) {
                self.tourProgress[tour.id] = progress
            }
        }
        /*
        print("PRINTING TOUR PROGRESS")
        for key in self.tourProgress.keys {
            print("id: \(tourProgress[key]?.id ?? "") \nstop progress: \(tourProgress[key]?.stopProgress)\n")
        }
         */
        print("END GETTOURPROGRESS")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
