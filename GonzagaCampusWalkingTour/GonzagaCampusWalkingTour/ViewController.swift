//
//  ViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 10/23/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var databaseReference: DatabaseAccessible?

    @IBAction func buttonPressed(_ sender: Any) {
        // moves to the tourList when begin it tapped.
        let test = UIStoryboard(name: "Main", bundle: nil)
        if let tourList = test.instantiateViewController(withIdentifier: "TourTableViewController") as? TourTableViewController {
            tourList.modalPresentationStyle = .fullScreen
            tourList.databaseReference = self.databaseReference
            //self.present(tourList, animated: true, completion: nil)
            self.navigationController?.pushViewController(tourList, animated: true)
        }
    }
    
    @IBAction func AdminLoginButtonPressed(_ sender: Any) {
        //self.performSegue(withIdentifier: "AdminLoginSegue", sender: self)
        let test = UIStoryboard(name: "Main", bundle: nil)
        let admin = test.instantiateViewController(withIdentifier: "AdminLoginViewController")
        self.present(admin, animated: true, completion: nil)
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
    
    @IBAction func statsButtonPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let statsVC = storyBoard.instantiateViewController(withIdentifier: "StatisticsViewController") as? StatisticsViewController {
            statsVC.databaseReference = self.databaseReference
            self.navigationController?.pushViewController(statsVC, animated: true)
        }
    }


    @IBAction func statsButtonPressed(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let statsVC = storyBoard.instantiateViewController(withIdentifier: "StatisticsViewController") as? StatisticsViewController {
            statsVC.databaseReference = self.databaseReference
            self.navigationController?.pushViewController(statsVC, animated: true)
        }
    }
}

