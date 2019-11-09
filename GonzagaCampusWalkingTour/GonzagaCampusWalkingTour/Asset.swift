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
    var assetName: String
    var asset: UIImage? // will need to later add video capabilities
    var assetDescription: String?
    
    
    //MARK: Initialization
    init?(assetName: String, asset: UIImage?, assetDescription: String) {
        // if there is no name, initialization fails
        if assetName.isEmpty {
            return nil
        }
        
        self.assetName = assetName
        self.asset = asset
        self.assetDescription = assetDescription
    }
    
}

