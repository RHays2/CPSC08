//
//  TourDescriptionViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 11/10/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit
/*
 TODO:
    - allow all text boxes to wrap
    - allow text boxes to be sized based on size of text
    - resize image to always fit the screen
    - set autolayout constraints for all ui objects
 */
class TourDescriptionViewController: UIViewController {
    @IBOutlet weak var tourName: UILabel!
    @IBOutlet weak var tourPreviewImage: UIImageView!
    @IBOutlet weak var tourDescription: UITextView!
    @IBOutlet weak var tourLength: UITextView!
    
    var selectedTour:Tour?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationItemBar()
        initTourDetails()
    }
    
    func initTourDetails() {
        tourName.text = selectedTour?.tourName
        tourPreviewImage.image = selectedTour?.tourImage
        tourDescription.text = selectedTour?.tourDescription
        tourLength.text = "Tour Length: \(selectedTour?.tourDistance ?? 0.0) mi"
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
    }
    
    @objc func startTour() {
        //start the google maps view
        let googleMapsViewController = GoogleMapsViewController(nibName: nil, bundle: nil)
        googleMapsViewController.modalPresentationStyle = .fullScreen
        googleMapsViewController.activeTour = selectedTour
        self.present(googleMapsViewController, animated: true, completion: nil)
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
