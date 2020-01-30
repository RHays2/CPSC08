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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //makes the back button show just "< Back"
        let myBackButton = UIBarButtonItem()
        myBackButton.title = "Back"
        navigationItem.backBarButtonItem = myBackButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TourDescriptionViewController {
            //set the selectedTour in TourDescriptionViewController
            destination.selectedTour = tours[(tableView.indexPathForSelectedRow?.row)!]
            //deselct row
            tableView.deselectRow(at: tableView!.indexPathForSelectedRow!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up a placeholder asset, stop, and multiple tours
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //perform segue to the TourDescriptionViewController
        performSegue(withIdentifier: "toTourDescriptionSegue", sender: self)
        // for now, selecting a tour takes the user straight to the map
//        let googleMapsViewController = GoogleMapsViewController(nibName: nil, bundle: nil)
//        googleMapsViewController.modalPresentationStyle = .fullScreen
//        self.present(googleMapsViewController, animated: true, completion: nil)
    }

    //MARK: Private Methods
    private func loadPlaceholderTours() {
        // get tour images
        let tourPhoto1 = UIImage(named: "DefaultTour1")!
        let tourPhoto2 = UIImage(named: "DefaultTour2")!
        let tourPhoto3 = UIImage(named: "DefaultTour3")!
        let tourPhoto4 = UIImage(named: "DefaultTour4")!
        let tourPhoto5 = UIImage(named: "DefaultTour5")!
        let tourPhoto6 = UIImage(named: "DefaultTour6")!
        let tourPhoto7 = UIImage(named: "DefaultTour7")!
        let tourPhoto8 = UIImage(named: "DefaultTour8")!
        let tourPhoto9 = UIImage(named: "DefaultTour9")!
        let tourPhoto10 = UIImage(named: "DefaultTour10")!
        let tourPhoto11 = UIImage(named: "DefaultTour11")!
        
        // get stop images
        let stop1Image1 = UIImage(named: "Stop1Image1")!
        let stop1Image2 = UIImage(named: "Stop1Image2")!
        let stop1Image3 = UIImage(named: "Stop1Image3")!
        let stop2Image1 = UIImage(named: "Stop2Image1")!
        let stop2Image2 = UIImage(named: "Stop2Image2")!
        let stop2Image3 = UIImage(named: "Stop2Image3")!
        let stop3Image1 = UIImage(named: "Stop3Image1")!
        let stop3Image2 = UIImage(named: "Stop3Image2")!
        let stop3Image3 = UIImage(named: "Stop3Image3")!
        
        
        // set up a default asset
        guard let asset1 = Asset(assetName: "DefaultAsset1", asset: tourPhoto1, assetDescription: "An aerial view of campus")
            else {
                fatalError("Unable to instantiate DefaultAsset1")
        }
        
        // set up assets for paccar stops
        guard let paccarAsset1 = Asset(assetName: "Paccar Asset 1", asset: stop1Image1, assetDescription: "This is paccar stop 1 asset 1")
            else {
                fatalError("Unable to instantiate paccarAsset1")
        }
        guard let paccarAsset2 = Asset(assetName: "Paccar Asset 2", asset: stop1Image2, assetDescription: "This is paccar stop 1 asset 2. This has a longer description because the description may have to be scrollable in fact it really should be so we want to have a ton of text here so that we can see if we can actually scroll to see it all. Sorry that the descriptions are so boring but they are just stand ins and I wasn't about to go take pictures and describe them and there aren't enough available images on google of specific parts of campus. lalala. Stop reading it's the same. This has a longer description because the description may have to be scrollable in fact it really should be so we want to have a ton of text here so that we can see if we can actually scroll to see it all. Sorry that the descriptions are so boring but they are just stand ins and I wasn't about to go take pictures and describe them and there aren't enough available images on google of specific parts of campus. lalala.")
            else {
                fatalError("Unable to instantiate paccarAsset2")
        }
        guard let paccarAsset3 = Asset(assetName: "Paccar Asset 3", asset: stop1Image3, assetDescription: "This is paccar stop 1 asset 3")
            else {
                fatalError("Unable to instantiate paccarAsset3")
        }
        guard let paccarAsset4 = Asset(assetName: "Paccar Asset 4", asset: stop2Image1, assetDescription: "This is paccar stop 2 asset 1")
            else {
                fatalError("Unable to instantiate paccarAsset4")
        }
        guard let paccarAsset5 = Asset(assetName: "Paccar Asset 2", asset: stop2Image2, assetDescription: "This is paccar stop 2 asset 2")
            else {
                fatalError("Unable to instantiate paccarAsset5")
        }
        guard let paccarAsset6 = Asset(assetName: "Paccar Asset 3", asset: stop2Image3, assetDescription: "This is paccar stop 2 asset 3")
            else {
                fatalError("Unable to instantiate paccarAsset6")
        }
        guard let paccarAsset7 = Asset(assetName: "Paccar Asset 1", asset: stop3Image1, assetDescription: "This is paccar stop 3 asset 1")
            else {
                fatalError("Unable to instantiate paccarAsset7")
        }
        guard let paccarAsset8 = Asset(assetName: "Paccar Asset 2", asset: stop3Image2, assetDescription: "This is paccar stop 3 asset 2")
            else {
                fatalError("Unable to instantiate paccarAsset8")
        }
        guard let paccarAsset9 = Asset(assetName: "Paccar Asset 3", asset: stop3Image3, assetDescription: "This is paccar stop 3 asset 3")
            else {
                fatalError("Unable to instantiate paccarAsset9")
        }
        
        let paccar1Assets = [paccarAsset1, paccarAsset2, paccarAsset3]
        let paccar2Assets = [paccarAsset4, paccarAsset5, paccarAsset6]
        let paccar3Assets = [paccarAsset7, paccarAsset8, paccarAsset9]
        
        
        
//        guard let stop1 = Stop(stopName: "DefaultStop1", stopDescription: "An example stop", stopAssets: [asset1], stopLatitude: 47.668112, stopLongitude: -117.402269)
//            else {
//                fatalError("Unable to instantiate DefaultStop1")
//            }
        
        guard let cHall1 = Stop(stopName: "College Hall Stop 1", stopDescription: "College Hall Stop 1", stopAssets: [asset1], stopLatitude: 47.668112, stopLongitude: -117.401748, order: 1)
            else {
                fatalError("Unable to instantiate cHall1")
        }
        guard let cHall2 = Stop(stopName: "College Hall Stop 2", stopDescription: "College Hall Stop 2", stopAssets: [asset1], stopLatitude: 47.668108, stopLongitude: -117.402419, order: 2)
            else {
                fatalError("Unable to instantiate cHall2")
        }
        guard let cHall3 = Stop(stopName: "College Hall Stop 3", stopDescription: "College Hall Stop 3", stopAssets: [asset1], stopLatitude: 47.668101, stopLongitude: -117.403331, order: 3)
            else {
                fatalError("Unable to instantiate cHall3")
        }
        
        
        guard let tour1 = Tour(tourName: "College Hall", tourImage:tourPhoto1, tourDescription: "A tour of the first building of Gonzaga", tourStops: [cHall1, cHall2, cHall3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour1")
        }
        
        guard let foley1 = Stop(stopName: "Foley Library Stop 1", stopDescription: "Foley Library Stop 1", stopAssets: [asset1], stopLatitude: 47.666714, stopLongitude: -117.401201, order: 1)
            else {
                fatalError("Unable to instantiate foley1")
        }
        guard let foley2 = Stop(stopName: "Foley Library Stop 2", stopDescription: "Foley Library Stop 2", stopAssets: [asset1], stopLatitude: 47.666439, stopLongitude: -117.400917, order: 2)
            else {
                fatalError("Unable to instantiate foley2")
        }
        guard let foley3 = Stop(stopName: "Foley Library Stop 3", stopDescription: "Foley Library Stop 3", stopAssets: [asset1], stopLatitude: 47.666526, stopLongitude: -117.400322, order: 3)
            else {
                fatalError("Unable to instantiate foley3")
        }
        guard let tour2 = Tour(tourName: "Foley", tourImage:tourPhoto2, tourDescription: "A tour of the library", tourStops: [foley1, foley2, foley3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour2")
        }
        
        guard let hemmy1 = Stop(stopName: "Hemmingson Stop 1", stopDescription: "Hemmingson Stop 1", stopAssets: [asset1], stopLatitude: 47.667126, stopLongitude: -117.399839, order: 1)
            else {
                fatalError("Unable to instantiate hemmy1")
        }
        guard let hemmy2 = Stop(stopName: "Hemmingson Stop 2", stopDescription: "Hemmingson Stop 2", stopAssets: [asset1], stopLatitude: 47.667090, stopLongitude: -117.399211, order: 2)
            else {
                fatalError("Unable to instantiate hemmy2")
        }
        guard let hemmy3 = Stop(stopName: "COG", stopDescription: "Hemmingson Stop 3", stopAssets: [asset1], stopLatitude: 47.667101, stopLongitude: -117.398380, order: 3)
            else {
                fatalError("Unable to instantiate hemmy3")
        }
        guard let tour3 = Tour(tourName: "Hemmingson", tourImage:tourPhoto3, tourDescription: "A tour of offices and food", tourStops: [hemmy1, hemmy2, hemmy3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour3")
        }
        
        
        guard let paccar1 = Stop(stopName: "It's okay to fail", stopDescription: "Paccar Stop 1", stopAssets: paccar1Assets, stopLatitude: 47.666364, stopLongitude: -117.401840, order: 1)
            else {
                fatalError("Unable to instantiate paccar1")
        }
        guard let paccar2 = Stop(stopName: "Dean's Office", stopDescription: "Paccar Stop 2", stopAssets: paccar2Assets, stopLatitude: 47.666328, stopLongitude: -117.402130, order: 2)
            else {
                fatalError("Unable to instantiate paccar2")
        }
        guard let paccar3 = Stop(stopName: "Sky Bridge", stopDescription: "Paccar Stop 3", stopAssets: paccar3Assets, stopLatitude: 47.666491, stopLongitude: -117.402446, order: 3)
            else {
                fatalError("Unable to instantiate paccar3")
        }
        guard let tour4 = Tour(tourName: "Paccar", tourImage:tourPhoto4, tourDescription: "A tour of Science and Engineering", tourStops: [paccar1, paccar2, paccar3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour4")
        }
        
        guard let luger1 = Stop(stopName: "Luger Stop 1", stopDescription: "Luger Stop 1", stopAssets: [asset1], stopLatitude: 47.665949, stopLongitude:  -117.402119, order: 1)
            else {
                fatalError("Unable to instantiate luger1")
        }
        guard let luger2 = Stop(stopName: "Luger Stop 2", stopDescription: "Luger Stop 2", stopAssets: [asset1], stopLatitude: 47.665310, stopLongitude: -117.402103, order: 2)
            else {
                fatalError("Unable to instantiate luger2")
        }
        guard let luger3 = Stop(stopName: "Luger Stop 3", stopDescription: "Luger Stop 3", stopAssets: [asset1], stopLatitude: 47.664508, stopLongitude: -117.402039, order: 3)
            else {
                fatalError("Unable to instantiate luger3")
        }
        guard let tour5 = Tour(tourName: "Luger Field", tourImage:tourPhoto5, tourDescription: "A tour of where soccer is played", tourStops: [luger1, luger2, luger3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour5")
        }
        
        
        guard let parking1 = Stop(stopName: "Parking Stop 3", stopDescription: "Parking Stop 1", stopAssets: [asset1], stopLatitude: 47.664364, stopLongitude: -117.398905, order: 1)
            else {
                fatalError("Unable to instantiate parking1")
        }
        guard let parking2 = Stop(stopName: "Parking Stop 3", stopDescription: "Parking Stop 2", stopAssets: [asset1], stopLatitude: 47.668009, stopLongitude: -117.397076, order: 2)
            else {
                fatalError("Unable to instantiate parking2")
        }
        guard let parking3 = Stop(stopName: "Parking Stop 3", stopDescription: "Parking Stop 3", stopAssets: [asset1], stopLatitude: 47.668770, stopLongitude: -117.402216, order: 3)
            else {
                fatalError("Unable to instantiate parking3")
        }
        guard let tour6 = Tour(tourName: "Parking", tourImage:tourPhoto6, tourDescription: "A tour of where to park on campus", tourStops: [parking1, parking2, parking3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour6")
        }
        
        
        guard let rosauer1 = Stop(stopName: "Rosauer Stop 3", stopDescription: "Rosauer Stop 1", stopAssets: [asset1], stopLatitude: 47.668123, stopLongitude: -117.399453, order: 1)
            else {
                fatalError("Unable to instantiate rosauer1")
        }
        guard let rosauer2 = Stop(stopName: "Rosauer Stop 3", stopDescription: "Rosauer Stop 2", stopAssets: [asset1], stopLatitude: 47.668137, stopLongitude: -117.399147, order: 2)
            else {
                fatalError("Unable to instantiate rosauer2")
        }
        guard let rosauer3 = Stop(stopName: "Rosauer Stop 3", stopDescription: "Rosauer Stop 3", stopAssets: [asset1], stopLatitude: 47.668076, stopLongitude: -117.398809, order: 3)
            else {
                fatalError("Unable to instantiate rosauer3")
        }
        guard let tour7 = Tour(tourName: "Rosauer", tourImage:tourPhoto7, tourDescription: "A tour of the School of Education", tourStops: [rosauer1, rosauer2, rosauer3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour7")
        }
        
        
        guard let desmet1 = Stop(stopName: "Desmet Stop 1", stopDescription: "Desmet Stop 1", stopAssets: [asset1], stopLatitude: 47.667945, stopLongitude: -117.401122, order: 1)
            else {
                fatalError("Unable to instantiate desmet1")
        }
        guard let desmet2 = Stop(stopName: "Desmet Stop 2", stopDescription: "Desmet Stop 2", stopAssets: [asset1], stopLatitude: 47.667849, stopLongitude: -117.401126, order: 2)
            else {
                fatalError("Unable to instantiate desmet2")
        }
        guard let desmet3 = Stop(stopName: "Desmet Stop 3", stopDescription: "Desmet Stop 3", stopAssets: [asset1], stopLatitude: 47.667679, stopLongitude: -117.401078, order: 3)
            else {
                fatalError("Unable to instantiate desmet3")
        }
        guard let tour8 = Tour(tourName: "Desmet", tourImage:tourPhoto8, tourDescription: "A tour of the first dorm, which is to this day men only", tourStops: [desmet1, desmet2, desmet3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour8")
        }
        
        guard let coughlin1 = Stop(stopName: "Coughlin Stop 1", stopDescription: "Coughlin Stop 1", stopAssets: [asset1], stopLatitude: 47.664924, stopLongitude: -117.396824, order: 1)
            else {
                fatalError("Unable to instantiate coughlin1")
        }
        guard let coughlin2 = Stop(stopName: "Coughlin Stop 2", stopDescription: "Coughlin Stop 2", stopAssets: [asset1], stopLatitude: 47.664577, stopLongitude: -117.396878, order: 2)
            else {
                fatalError("Unable to instantiate coughlin2")
        }
        guard let coughlin3 = Stop(stopName: "Coughlin Stop 3", stopDescription: "Coughlin Stop 3", stopAssets: [asset1], stopLatitude: 47.665220, stopLongitude: -117.396867, order: 3)
            else {
                fatalError("Unable to instantiate coughlin3")
        }
        guard let tour9 = Tour(tourName: "Coughlin", tourImage:tourPhoto9, tourDescription: "A tour of a newer dorm", tourStops: [coughlin1, coughlin2, coughlin3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour9")
        }
        
        guard let jundt1 = Stop(stopName: "Jundt Stop 1", stopDescription: "Jundt Stop 1", stopAssets: [asset1], stopLatitude: 47.666333, stopLongitude: -117.407145, order: 1)
            else {
                fatalError("Unable to instantiate jundt1")
        }
        guard let jundt2 = Stop(stopName: "Jundt Stop 2", stopDescription: "Jundt Stop 2", stopAssets: [asset1], stopLatitude: 47.666331, stopLongitude: -117.406870, order: 2)
            else {
                fatalError("Unable to instantiate jundt2")
        }
        guard let jundt3 = Stop(stopName: "Jundt Stop 3", stopDescription: "Jundt Stop 3", stopAssets: [asset1], stopLatitude: 47.666400, stopLongitude: -117.406532, order: 3)
            else {
                fatalError("Unable to instantiate jundt3")
        }
        guard let tour10 = Tour(tourName: "Jundt", tourImage:tourPhoto10, tourDescription: "A tour of the art museum", tourStops: [jundt1, jundt2, jundt3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate DefaultTour10")
        }

        guard let jepson1 = Stop(stopName: "Jepson Stop 1", stopDescription: "Jepson Stop 1", stopAssets: [asset1], stopLatitude: 47.666989, stopLongitude: -117.405009, order: 1)
            else {
                fatalError("Unable to instantiate jepson1")
        }
        guard let jepson2 = Stop(stopName: "Jepson Stop 2", stopDescription: "Jepson Stop 2", stopAssets: [asset1], stopLatitude: 47.667256, stopLongitude: -117.405194, order: 2)
            else {
                fatalError("Unable to instantiate jepson2")
        }
        guard let jepson3 = Stop(stopName: "Jepson Stop 3", stopDescription: "Jepson Stop 3", stopAssets: [asset1], stopLatitude: 47.667133, stopLongitude: -117.405641, order: 3)
            else {
                fatalError("Unable to instantiate jepson3")
        }
        guard let tour11 = Tour(tourName: "Jepson", tourImage:tourPhoto11, tourDescription: "A tour of the business building", tourStops: [jepson1, jepson2, jepson3], tourDistance: 0.5, tourTime: 30) else {
            fatalError("Unable to instantiate defaultTour11")
        }

        
        
        tours += [tour1, tour2, tour3, tour4, tour5, tour6, tour7, tour8, tour9, tour10, tour11]
    }
}
