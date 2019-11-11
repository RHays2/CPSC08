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
    var stopLatitude: Float // I think latitude and longitude as floats could be useful representaitons of stop locations -Mason
    var stopLongitude: Float
    
    
    
    //MARK: Initialization
    init?(stopName: String, stopDescription: String, stopAssets: [Asset], stopLatitude: Float, stopLongitude: Float) {
        // if there is no name, initialization fails
        guard !stopName.isEmpty else {
            return nil
        }
        
        self.stopName = stopName
        self.stopDescription = stopDescription
        self.stopAssets = stopAssets
        self.stopLatitude = stopLatitude
        self.stopLongitude = stopLongitude
    }
    
}

