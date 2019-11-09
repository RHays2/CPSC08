//
//  asset.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class Asset {
    
    //MARK: Properties
    var asset_name: String
    var asset: UIImage? // will need to later add video capabilities
    var asset_description: String?
    
    
    //MARK: Initialization
    init?(asset_name: String, asset: UIImage?, asset_description: String) {
        // if there is no name, initialization fails
        if asset_name.isEmpty {
            return nil
        }
        
        self.asset_name = asset_name
        self.asset = asset
        self.asset_description = asset_description
    }
    
}

