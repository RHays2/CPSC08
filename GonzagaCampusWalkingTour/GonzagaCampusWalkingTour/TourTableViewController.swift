//
//  TourTableViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class TourTableViewController: UITableViewController {
    //MARK: Properties
    var tours = [Tour]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up a placeholder asset, stop, and 5 tours
        loadPlaceholderTours()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // number of table sections, for us just one
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tours.count // each section (in this case just one) has tours.count number of rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        // a method to "configure and provide a cell to display for a given row"
        
        let cellIdentifier = "TourTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath)
            as? TourTableViewCell else { // downcast to a TourTableViewCell
                fatalError("The dequeued cell is not an instance of TourTableViewCell")
        }
        
        let tour = tours[indexPath.row] // set the tour to be displayed in this cell
        
        // configure the cell
        cell.tourName.text = tour.tourName
        cell.tourImage.image = tour.tourImage
        cell.tourDescription.text = tour.tourDescription
        
        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    //MARK: Private Methods
    private func loadPlaceholderTours() {
        let tourPhoto1 = UIImage(named: "DefaultTour1")!
        let tourPhoto2 = UIImage(named: "DefaultTour2")!
        let tourPhoto3 = UIImage(named: "DefaultTour3")!
        let tourPhoto4 = UIImage(named: "DefaultTour4")!
        let tourPhoto5 = UIImage(named: "DefaultTour5")!
    
        guard let asset1 = Asset(assetName: "DefaultAsset1", asset: tourPhoto1, assetDescription: "An aerial view of campus")
            else {
                fatalError("Unable to instantiate DefaultAsset1")
        }
        guard let stop1 = Stop(stopName: "DefaultStop1", stopDescription: "An example stop", stopAssets: [asset1])
            else {
                fatalError("Unable to instantiate DefaultStop1")
            }
        
        guard let tour1 = Tour(tourName: "College Hall", tourImage:tourPhoto1, tourDescription: "A tour of the first building of Gonzaga", tourStops: [stop1], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour1")
        }
        guard let tour2 = Tour(tourName: "Foley", tourImage:tourPhoto2, tourDescription: "A tour of the library", tourStops: [stop1], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour2")
        }
        guard let tour3 = Tour(tourName: "Hemmy", tourImage:tourPhoto3, tourDescription: "A tour of offices and food", tourStops: [stop1], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour3")
        }
        guard let tour4 = Tour(tourName: "Paccar", tourImage:tourPhoto4, tourDescription: "A tour of Science and Engineering", tourStops: [stop1], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour4")
        }
        guard let tour5 = Tour(tourName: "Field", tourImage:tourPhoto5, tourDescription: "A tour of where soccer is played", tourStops: [stop1], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour5")
        }
        tours += [tour1, tour2, tour3, tour4, tour5]
    }
}
