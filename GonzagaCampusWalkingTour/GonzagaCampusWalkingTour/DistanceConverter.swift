//
//  DistanceConverter.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/12/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation

class DistanceConverter {
    static let MILES_IN_METER = 0.000621371;
    
    static func metersToMiles(meters: Double) -> Double {
        return (meters * DistanceConverter.MILES_IN_METER);
    }
}
