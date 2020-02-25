//
//  TourDescriptionViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 11/10/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class TourDescriptionViewController: UIViewController {
    @IBOutlet weak var tourName: UILabel!
    @IBOutlet weak var tourPreviewImage: UIImageView!
    @IBOutlet weak var tourDescription: UITextView!
    @IBOutlet weak var tourLength: UITextView!
    
    var selected:Tour?
    var selectedTour: TourInfo?
    var databaseReference: DatabaseAccessible?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationItemBar()
        initTourDetails()
    }
    
    func initTourDetails() {
        tourName.text = selectedTour?.tourName
        tourPreviewImage.image = selectedTour?.previewImage
        tourDescription.text = selectedTour?.tourDescription
        tourLength.text = "Tour Length: \(selectedTour?.tourLength ?? 0.0) mi"
    }
    
    func initNavigationItemBar() {
        //set the title
        navigationItem.title = "Tour Description"
        //set the start tour button
        let startTourButton = UIBarButtonItem(
            title: "Start Tour",
            style: .plain,
            target: self,
            action: #selector(startTour)
        )
        navigationItem.rightBarButtonItem = startTourButton
        //make the back button say just "back"
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func startTour() {
        //start the google maps view
//        let googleMapsViewController = GoogleMapsViewController(nibName: nil, bundle: nil)
//        googleMapsViewController.modalPresentationStyle = .fullScreen
//        googleMapsViewController.activeTour = selectedTour
//        self.present(googleMapsViewController, animated: true, completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let mapView = storyBoard.instantiateViewController(withIdentifier: "GoogleMapsViewController") as? GoogleMapsViewController {
            mapView.active = selected
            mapView.activeTour = selectedTour
            mapView.databaseReference = self.databaseReference
            mapView.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(mapView, animated: true)
        }
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
