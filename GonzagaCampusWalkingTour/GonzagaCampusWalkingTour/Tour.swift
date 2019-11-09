//
//  Tour.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class tour {
    
    //MARK: Properties
    var tour_name: String
    var tour_description: String?
    var tour_stops = [Stop]()
    // var tour_location: // not sure what datatype to represent the tour's location for google maps
    
    
    
    //MARK: Initialization
    init?(tour_name: String, tour_description: String, tour_stops: [Stop]) {
        // if there is no name, initialization fails
        guard !tour_name.isEmpty else {
            return nil
        }
        
        self.tour_name = tour_name
        self.tour_description = tour_description
        self.tour_stops = tour_stops
    }
    
}

