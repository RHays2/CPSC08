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
    var stop_name: String
    var stop_description: String?
    var stop_assets = [Asset]()
    // var stop_location: // not sure what datatype to represent the stop's location for google maps
    
    
    
    //MARK: Initialization
    init?(stop_name: String, stop_description: String, stop_assets: [Asset]) {
        // if there is no name, initialization fails
        guard !stop_name.isEmpty else {
            return nil
        }
        
        self.stop_name = stop_name
        self.stop_description = stop_description
        self.stop_assets = stop_assets
    }
    
}

