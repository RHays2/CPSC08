//
//  OrderedCoordinate.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 1/26/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import MapKit

class OrderedCoordinate {
    var coordinate: CLLocationCoordinate2D
    var order: Int
    
    init(coordinate: CLLocationCoordinate2D, order: Int) {
        self.coordinate = coordinate
        self.order = order
    }
}

