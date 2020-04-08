//
//  AdminInfoViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/8/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI


class AdminInfoViewController: UIViewController {
    var user: User?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addUserName()
    }
    
    func addUserName() {
        if self.user != nil {
            self.userNameLabel.text = self.user?.email
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        let alertMsg = "Are you sure you want to reset log out?"
        let alert = UIAlertController(title: "Log Out", message: alertMsg, preferredStyle: .alert)
        //create an action for if the reset button is pressed
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(alertAction) in
            //log the user out
            if let authUI = FUIAuth.defaultAuthUI() {
                do {
                    try authUI.signOut()
                } catch {
                    print(error)
                }
            }
            //return to previous screen
            self.navigationController?.popViewController(animated: true)
        })
        //create an action for a cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        //present alert dialog
        self.present(alert, animated: true, completion: nil)
        
    }
}
