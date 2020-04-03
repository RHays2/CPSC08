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
    var assetURL: String?
    var id: String
    
    init(assetName: String, asset: UIImage?, assetDescription: String, id:String) {
        self.assetName = assetName
        self.asset = asset
        self.assetDescription = assetDescription
        self.id = id
    }
    
    init(assetName: String, assetURL: String?, assetDescription: String, id:String) {
        self.assetName = assetName
        self.assetURL = assetURL
        self.assetDescription = assetDescription
        self.id = id
    }
}

