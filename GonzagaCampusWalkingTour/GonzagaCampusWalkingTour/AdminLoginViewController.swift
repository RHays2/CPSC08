//
//  AdminLoginViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Hays, Ryan T on 10/29/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class AdminLoginViewController: UIViewController {
    
    @IBAction func BackToStartButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {

        // get the default auth ui object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            //Log the error
            return
        }
        
        // set ourselves as delegate
        
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        // get a reference to the auth ui view controller
        
        let authViewController = authUI!.authViewController()
        //show it
        
        present(authViewController, animated: true, completion: nil)
        
    }
}

extension AdminLoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        // check if there was an error
        guard error == nil else {
            // Log error
            return
        }
        
        //we would use the below command to get a user id if we needed it to send them on different tours or something
        //authDataResult?.user.uid
        
        performSegue(withIdentifier: "goHome", sender: self)
    }
}
