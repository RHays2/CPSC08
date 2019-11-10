//
//  ViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 10/23/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: Any) {
        // moves to the tourList when begin it tapped.
        let test = UIStoryboard(name: "Main", bundle: nil)
        let admin = test.instantiateViewController(withIdentifier: "TourTableViewControllerNav")
        self.present(admin, animated: true, completion: nil)
        
        // previous code to move to the googleMaps screen from the landing screen.
//        let googleMapsViewController = GoogleMapsViewController(nibName: nil, bundle: nil)
//        googleMapsViewController.modalPresentationStyle = .fullScreen
//        self.present(googleMapsViewController, animated: true, completion: nil)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

