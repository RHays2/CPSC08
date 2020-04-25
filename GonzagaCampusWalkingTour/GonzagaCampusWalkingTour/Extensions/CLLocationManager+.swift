//
//  CLLocationManager+.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/21/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationManager {
    func requestNotificationPermissions() {
        //make sure we have location services
        guard CLLocationManager.locationServicesEnabled() else { return }
        
    }
}
