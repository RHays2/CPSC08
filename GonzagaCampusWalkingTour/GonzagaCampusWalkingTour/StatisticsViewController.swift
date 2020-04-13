//
//  StatisticsViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Ryan Hays on 3/29/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//
import UIKit

class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var databaseReference: DatabaseAccessible?
    var tourProgressRetriever: TourProgressRetrievable = UserDefaultsProgressRetrieval()
    let tempList = ["tour 1", "Tour 2", "Tour 3"]
    var tourProgress: [TourProgress] = []
    var tourInfo: [TourInfo] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(tempList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TourCell")
        cell.textLabel?.text = tempList[indexPath.row]
        return(cell)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getTourInfo()
        print("END GETTOURINFO")
    }
    
    func getTourInfo() {
        if self.databaseReference != nil {
            self.databaseReference?.getAllTourInfo(callback: {(tours) in
                self.tourInfo = tours
                self.getTourProgress()
                
                print("PRINTING TOUR INFO")
                for tour in tours {
                    print("name: \(tour.tourName) \nid: \(tour.id)\n")
                }
            })
        }
        print("END GETTOURINFO")
    }
    
    func getTourProgress() {
        for tour in self.tourInfo {
            if let progress = self.tourProgressRetriever.getTourProgress(tourId: tour.id) {
                self.tourProgress.append(progress)
            }
        }
        
        print("PRINTING TOUR PROGRESS")
        for tourProgress in self.tourProgress {
            print("id: \(tourProgress.id) \nstop progress: \(tourProgress.stopProgress)\n")
        }
        print("END GETTOURPROGRESS")
    }
}
