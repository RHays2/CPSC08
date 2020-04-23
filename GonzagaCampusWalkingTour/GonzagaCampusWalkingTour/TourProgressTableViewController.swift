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
    let tempList = ["tour 1", "Tour 2", "Tour 3"]
    var tourProgress: [String:TourProgress] = [:]
    var toursInfo: [TourInfo] = []
    var testDict = [100: "Hundred", 200: "two", 300:"three"]
    var tourProgressDict: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTourInfo()
        //self.tableView.reloadData()
        print("END VIEWDIDLOAD")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("VIEWWILLAPPEAR")
        print(self.tourProgressDict)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //print("TOURSINFO.COUNT")
        return toursInfo.count
        //return(tempList.count)
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

            print(toursInfo[indexPath.row].tourName)
            print(progress.stopProgress)
            for (_, val) in progress.stopProgress {
                if val == true {
                    stopsVisitedCount += 1
                }
            }
            print(stopsVisitedCount)
            print(progress.stopProgress.count)
            print("RIGHT HERE")
            print(progress.tourCompleted)
            print(progress.dateCompleted)
            cell.textLabel?.text = toursInfo[indexPath.row].tourName
            if progress.tourCompleted == true {
                cell.detailTextLabel?.text = "Tour Completed on: \(progress.dateCompleted)"
            }
            else {
            cell.detailTextLabel?.text = "\(stopsVisitedCount) / \(totalCount)"
            }
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
                
                print("PRINTING TOUR INFO")
                for tour in tours {
                    print("name: \(tour.tourName) \nid: \(tour.id)\n")
                    self.tourProgressDict[tour.tourName] = tour.id
                }
                print(self.tourProgressDict)
                self.tableView.reloadData()
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
        
        print("PRINTING TOUR PROGRESS")
        for key in self.tourProgress.keys {
            print("id: \(tourProgress[key]?.id ?? "") \nstop progress: \(tourProgress[key]?.stopProgress)\n")
        }
        print("END GETTOURPROGRESS")
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
