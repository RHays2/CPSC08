//
//  DistanceTracker.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/12/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import CoreLocation

class DistanceTracker {
    var currentPosition: CLLocation?;
    var currentDistance: Double;
    
    init(initialDistance: Double, initialPosition: CLLocation) {
        self.currentPosition = initialPosition;
        self.currentDistance = initialDistance;
    }
    
    init(initialDistance: Double) {
        self.currentDistance = initialDistance;
    }
    
    func updateCurrentPosition(newPosition: CLLocation) {
        //measure distance travelled from last position
        let distance = self.currentPosition?.distance(from: newPosition)
        //covert distance to miles
        if distance != nil {
            let distanceMiles = DistanceConverter.metersToMiles(meters: distance ?? 0.0)
            //update currentDistance
            self.currentDistance += distanceMiles
        }
        self.currentPosition = newPosition
    }
}
