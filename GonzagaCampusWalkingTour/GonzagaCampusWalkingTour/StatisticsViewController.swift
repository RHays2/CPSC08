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
            })
        }
        print("END GETTOURINFO")
    }
    
    func getTourProgress() {
        for tour in self.tourInfo
        {
            if let progress = self.tourProgressRetriever.getTourProgress(tourId: tour.id) {
                self.tourProgress.append(progress)
            }
        }
        print("END GETTOURPROGRESS")
    }
}

/*
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

    override func viewDidLoad() {
        super.viewDidLoad()
        getTourInfo()
        print("Page Loaded")

        printTours()
    }
    
    func getTourInfo() {
        if self.databaseReference != nil {
            self.databaseReference?.getAllTourInfo(callback: {(tours) in
                self.tourInfo = tours
                self.getTourProgress()
            })
        }
    }
    
    func getTourProgress() {
        for tour in self.tourInfo {
            if let progress = self.tourProgressRetriever.getTourProgress(tourId: tour.id) {
                self.tourProgress.append(progress)
            }
        }
        print("HERES MY PRINTS")
        print(tourInfo)
        print(tourProgress)
        print(self.tourInfo)
        print(self.tourProgress)
        for tour in self.tourInfo {
            print(tour)
        }
        for progress in self.tourProgress {
            print(progress)
        }
    }
    
    func printTours() {
        print(tempList)
        for tour in self.tourInfo {
            print(tour)
        }
        print(tourInfo)
        print(tourProgress)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(tempList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TourCell")
        cell.textLabel?.text = tempList[indexPath.row]
        return(cell)
    }


    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(tempList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "TourCell")
        cell.textLabel?.text = tempList[indexPath.row]
        return(cell)
    }
 */
}

 */
