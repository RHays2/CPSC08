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
        self.performSegue(withIdentifier: "testSegue", sender: self)
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

