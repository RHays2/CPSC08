//
//  ViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 10/23/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class ViewController: UIViewController {
    var databaseReference: DatabaseAccessible?

    @IBAction func buttonPressed(_ sender: Any) {
        // moves to the tourList when begin it tapped.
        self.showTourListVC()
    }
    
    @IBAction func AdminLoginButtonPressed(_ sender: Any) {
        // get the default auth ui object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            //Log the error
            return
        }
        
        if authUI?.auth?.currentUser != nil {
            //if user already logged in display another VC with account info
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            if let adminInfoVC = storyBoard.instantiateViewController(withIdentifier: "AdminInfoViewController") as? AdminInfoViewController{
                adminInfoVC.user = authUI?.auth?.currentUser
                self.navigationController?.pushViewController(adminInfoVC, animated: true)
            }
        }
        else {
            //display the login view controller
            // set ourselves as delegate
            authUI?.delegate = self
            authUI?.providers = [FUIEmailAuth()]
            // get a reference to the auth ui view controller
            let authViewController = authUI!.authViewController()
            //show it
            present(authViewController, animated: true, completion: nil)
        }

    }
    
    func showTourListVC() {
        let test = UIStoryboard(name: "Main", bundle: nil)
        if let tourList = test.instantiateViewController(withIdentifier: "TourTableViewController") as? TourTableViewController {
            tourList.modalPresentationStyle = .fullScreen
            tourList.databaseReference = self.databaseReference
            //self.present(tourList, animated: true, completion: nil)
            self.navigationController?.pushViewController(tourList, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let stor = FirebaseStorageAccess()
        //stor.getImageNamed(name: "CollegeHall1.jpg")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //remove the nav bar from this view
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        //set the nav bar visible for all future views
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func StatsButtonPressed(_ sender: Any) {
//        let statsTabBarController = storyboard?.instantiateViewController(withIdentifier: "StatsTabBarController") as! StatsTabBarController
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let statsVC = storyBoard.instantiateViewController(withIdentifier: "StatsTabBarController") as? StatsTabBarController {
            statsVC.modalPresentationStyle = .fullScreen
            statsVC.databaseReference = self.databaseReference
            self.navigationController?.pushViewController(statsVC, animated: true)
        }
        
    }
    @IBAction func aboutButtonPressed(_ sender: Any) {
//        let aboutViewController = storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
//
//        present(aboutViewController, animated: true, completion: nil)
        
        let aboutViewController = UIStoryboard(name: "Main", bundle: nil)
        if let aboutView = aboutViewController.instantiateViewController(withIdentifier: "AboutViewController") as? AboutViewController {
            aboutView.modalPresentationStyle = .fullScreen
            //self.present(tourList, animated: true, completion: nil)
            self.navigationController?.pushViewController(aboutView, animated: true)
        }
        
    }
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // check if there was an error
        guard error == nil else {
            // Log error
            return
        }
        
        //we would use the below command to get a user id if we needed it to send them on different tours or something
        //authDataResult?.user.uid
        
        self.showTourListVC()
    }
}

