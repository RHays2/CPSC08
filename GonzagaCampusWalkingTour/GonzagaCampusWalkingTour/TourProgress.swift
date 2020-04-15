//
//  TourProgress.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/27/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation

class TourProgress: Codable {
    var id: String
    var distanceTraveled: Double
    var stopProgress:[String:Bool]
    var currentStop: Int
    var dateCompleted: String
    var tourCompleted: Bool
    
    init(id: String, distanceTravled: Double, stopProgress: [String:Bool], currentStop: Int, dateCompleted: String, tourCompleted: Bool) {
        self.id = id
        self.distanceTraveled = distanceTravled
        self.stopProgress = stopProgress
        self.currentStop = currentStop
        self.dateCompleted = dateCompleted
        self.tourCompleted = tourCompleted
    }
    
    func toString() -> String{
        return "id: \(id), distance traveled: \(distanceTraveled), stop progress: \(stopProgress)"
    }
}
