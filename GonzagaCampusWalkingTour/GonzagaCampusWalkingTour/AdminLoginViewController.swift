//
//  AdminLoginViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Hays, Ryan T on 10/29/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class AdminLoginViewController: UIViewController {
    
    @IBAction func BackToStartButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "BackToStartScreenSegue", sender: self)
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
