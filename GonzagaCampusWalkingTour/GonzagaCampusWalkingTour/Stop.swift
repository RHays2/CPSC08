//
//  Stop.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class Stop {
    
    //MARK: Properties
    var stopName: String
    var stopDescription: String?
    var stopAssets = [Asset]()
    // var stop_location: // not sure what datatype to represent the stop's location for google maps
    
    
    
    //MARK: Initialization
    init?(stopName: String, stopDescription: String, stopAssets: [Asset]) {
        // if there is no name, initialization fails
        guard !stopName.isEmpty else {
            return nil
        }
        
        self.stopName = stopName
        self.stopDescription = stopDescription
        self.stopAssets = stopAssets
    }
    
}

