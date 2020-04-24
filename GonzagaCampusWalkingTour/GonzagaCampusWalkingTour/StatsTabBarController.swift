//
//  StatsTabBarController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Ryan Hays on 4/19/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import UIKit

class StatsTabBarController : UITabBarController {
    var userProgressView:UserProgressViewController?
    var tourProgressView:TourProgressTableViewController?
    var databaseReference: DatabaseAccessible?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userProgressView = createUserProgressView()
        self.tourProgressView = createTourProgressView()
        
        createTabBarItems()
        
        let viewControllerList = [userProgressView, tourProgressView]
        viewControllers = viewControllerList as? [UIViewController]
    }
    
    func createTabBarItems() {
        //create a tab bar item for the stop view and images view
        self.userProgressView?.tabBarItem = UITabBarItem(title: "User Progress", image: UIImage(imageLiteralResourceName: "user"), tag: 0)
        self.tourProgressView?.tabBarItem = UITabBarItem(title: "Tour Progress", image: UIImage(imageLiteralResourceName: "pin"), tag: 1)
        
    }
    
    func createUserProgressView() -> UserProgressViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let userProgressController = (storyBoard.instantiateViewController(withIdentifier: "UserProgressViewController") as? UserProgressViewController) else {
            return nil
        }
        userProgressController.databaseReference = self.databaseReference
        return userProgressController
        
    }
    
    func createTourProgressView() -> TourProgressTableViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let tourProgressController = (storyBoard.instantiateViewController(withIdentifier: "TourProgressTableViewController") as? TourProgressTableViewController) else {
            return nil
        }
        tourProgressController.databaseReference = self.databaseReference
        return tourProgressController
        
    }
    
}
