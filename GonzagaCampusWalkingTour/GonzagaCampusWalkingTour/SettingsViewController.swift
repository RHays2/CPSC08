//
//  SettingsViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 3/6/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var tourProgress: TourProgress?
    var tourProgressRetriever: TourProgressRetrievable?
    
    @IBOutlet weak var progressResetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nav = self.navigationController {
            nav.topViewController?.title = "Settings"
        }
    }
    
    @IBAction func progressResetButtonPressed(_ sender: Any) {
        let alertMsg = "Are you sure you want to reset tour progress? Once you rest your progress it cannot be recovered"
        let alert = UIAlertController(title: "Reset Tour Progress", message: alertMsg, preferredStyle: .alert)
        //create an action for if the reset button is pressed
        let resetAction = UIAlertAction(title: "Reset", style: .default, handler: {(alertAction) in
            if let progress = self.tourProgress, let progressRetriever = self.tourProgressRetriever {
                //reset the progress
                progressRetriever.resetTourProgress(progress: progress)
            }
        })
        //create an action for a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(resetAction)
        alert.addAction(cancelAction)
        //present alert dialog
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let parentVC = self.navigationController?.topViewController as? GoogleMapsViewController {
            //update the progress label
            parentVC.setProgressLabel()
            //reset the directions path
            parentVC.addDirectionsPath()
            //update monitored region
            parentVC.updateMonitoredRegion()
        }
    }
}
