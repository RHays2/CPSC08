//
//  UIViewController+.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/18/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import UIKit

extension UIViewController {
    func createCenteredProgressIndicator() -> UIActivityIndicatorView{
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.frame = self.view.frame
        indicator.color = .gray
        if let nav = self.navigationController {
            let y = nav.navigationBar.frame.height
            let center = CGPoint(x: self.view.center.x, y: self.view.center.y - y)
            indicator.center = center
        } else { indicator.center = self.view.center }
        
        return indicator
    }
}
