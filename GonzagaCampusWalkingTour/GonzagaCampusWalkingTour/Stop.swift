//
//  Stop.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit
import GoogleMaps
class Stop: GMSMarker {
    
    //MARK: Properties
    var stopName: String
    var stopDescription: String?
    var stopAssets = [Asset]()
    var stopLatitude: Double
    var stopLongitude: Double
    var order: Int
    
    
    
    //MARK: Initialization
    init?(stopName: String, stopDescription: String, stopAssets: [Asset], stopLatitude: Double, stopLongitude: Double, order: Int) {
        // if there is no name, initialization fails
        guard !stopName.isEmpty else {
            return nil
        }
        
        self.stopName = stopName
        self.stopDescription = stopDescription
        self.stopAssets = stopAssets
        self.stopLatitude = stopLatitude
        self.stopLongitude = stopLongitude
        self.order = order
        
        super.init()
        self.position = CLLocationCoordinate2D(latitude: stopLatitude, longitude: stopLongitude)
        self.icon = UIImage(named: "question")
    }
    
}

