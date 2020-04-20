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
    var tourProgress: [TourProgress] = []
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
        return(toursInfo.count)
        //return(tempList.count)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourCell", for:indexPath)
        
        let totalCount = tourProgress[indexPath.row].stopProgress.count
        var stopsVisitedCount = 0

        print(toursInfo[indexPath.row].tourName)
        print(tourProgress[indexPath.row].stopProgress)
        for (_, val) in tourProgress[indexPath.row].stopProgress {
            if val == true {
                stopsVisitedCount += 1
            }
        }
        print(stopsVisitedCount)
        print(tourProgress[indexPath.row].stopProgress.count)
        cell.textLabel?.text = toursInfo[indexPath.row].tourName
        cell.detailTextLabel?.text = "\(stopsVisitedCount) / \(totalCount)"
        return(cell)
        
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
                self.tourProgress.append(progress)
            }
        }
        
        print("PRINTING TOUR PROGRESS")
        for tourProgress in self.tourProgress {
            print("id: \(tourProgress.id) \nstop progress: \(tourProgress.stopProgress)\n")
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
