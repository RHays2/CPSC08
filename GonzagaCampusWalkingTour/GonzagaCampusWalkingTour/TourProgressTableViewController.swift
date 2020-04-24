//
//  TourProgressTableViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Ryan Hays on 4/19/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import UIKit

class TourProgressTableViewController: UITableViewController {
    var databaseReference: DatabaseAccessible?
    var tourProgressRetriever: TourProgressRetrievable = UserDefaultsProgressRetrieval()
    var tourProgress: [String:TourProgress] = [:]
    var toursInfo: [TourInfo] = []
    var tourProgressDict: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTourInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toursInfo.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TourProgressFullViewController
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let tourProgressVC = (storyBoard.instantiateViewController(withIdentifier: "TourProgressFullViewController") as? TourProgressFullViewController) {
            tourProgressVC.selectedTour = self.toursInfo[indexPath.row]
            if let progress = self.tourProgress[self.toursInfo[indexPath.row].id] {
                tourProgressVC.selectedTourProgress = progress
            }
            else {
                tourProgressVC.selectedTourProgress = TourProgress(id: self.toursInfo[indexPath.row].id, distanceTravled: 0, stopProgress: [:], currentStop: 0, dateCompleted: "", tourCompleted: false)
            }
            self.navigationController?.pushViewController(tourProgressVC, animated: true)
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourCell", for:indexPath)
        let tour = toursInfo[indexPath.row]
        let tourId = toursInfo[indexPath.row].id
        
        if let progress = self.tourProgress[tourId] {
            let totalCount = Int(toursInfo[indexPath.row].tourLength)//tourProgress[indexPath.row].stopProgress.count
            var stopsVisitedCount = 0

            for (_, val) in progress.stopProgress {
                if val == true {
                    stopsVisitedCount += 1
                }
            }

            cell.textLabel?.text = toursInfo[indexPath.row].tourName
            cell.detailTextLabel?.text = "\(stopsVisitedCount) / \(totalCount)"
        }
        else {
            let total = Int(tour.tourLength)
            cell.textLabel?.text = tour.tourName
            cell.detailTextLabel?.text = "0 / \(total)"
        }
        
        return cell
        
    }
    
    func getTourInfo() {
        if self.databaseReference != nil {
            let indicator = self.createCenteredProgressIndicator()
            self.view.addSubview(indicator)
            indicator.startAnimating()
            self.databaseReference?.getAllTourInfo(callback: {(tours) in
                self.toursInfo = tours
                self.getTourProgress()
                
                for tour in tours {
                    self.tourProgressDict[tour.tourName] = tour.id
                }
                self.tableView.reloadData()
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
