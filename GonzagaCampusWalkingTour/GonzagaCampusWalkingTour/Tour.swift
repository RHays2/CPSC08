//
//  Tour.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class Tour {
    
    //MARK: Properties
    var tourName: String
    var tourDescription: String?
    var tourStops = [Stop]()
    var tourImage: UIImage
    // var tour_location: // not sure what datatype to represent the tour's location for google maps
    
    
    
    //MARK: Initialization
    init?(tourName: String, tourImage: UIImage, tourDescription: String, tourStops: [Stop]) {
        // if there is no name, initialization fails
        guard !tourName.isEmpty else {
            return nil
        }
        
        self.tourName = tourName
        self.tourImage = tourImage
        self.tourDescription = tourDescription
        self.tourStops = tourStops
    }
}

