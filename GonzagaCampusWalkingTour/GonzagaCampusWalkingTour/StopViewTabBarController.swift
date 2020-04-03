//
//  StopViewTabBarController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 11/26/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class StopViewTabBarController: UITabBarController {
    var stopView:TourStopViewController?
    var imagesView:StopViewImagesViewController?
    var curStop:Stop?
    var databaseReference: DatabaseAccessible?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create view controllers for each screen
        self.imagesView = createStopViewImageController()
        self.stopView = createStopViewController()
        //create the tab bar items for each view controller
        createTabBarItems()
        //add the view controllers to the viewControllers list
        let viewControllerList = [stopView, imagesView]
        viewControllers = viewControllerList as? [UIViewController]
    }
    
    func createTabBarItems() {
        //create a tab bar item for the stop view and images view
        self.stopView?.tabBarItem = UITabBarItem(title: "Description", image: UIImage(imageLiteralResourceName: "bookicon"), tag: 0)
        self.imagesView?.tabBarItem = UITabBarItem(title: "Photos", image: UIImage(imageLiteralResourceName: "photoicon"), tag: 1)
    }
    
    func createStopViewImageController() -> StopViewImagesViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let imagesController = (storyBoard.instantiateViewController(withIdentifier: "StopViewImagesViewController") as? StopViewImagesViewController) else {
            return nil
        }
        imagesController.curStop = curStop
        imagesController.databaseReference = self.databaseReference
        return imagesController
    }
    
    func createStopViewController() -> TourStopViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let stopViewController = (storyBoard.instantiateViewController(withIdentifier: "TourStopViewController") as? TourStopViewController) else {
            return nil
        }
        stopViewController.currentStop = self.curStop
        stopViewController.databaseReference = self.databaseReference
        return stopViewController
    }
}
