//
//  Path.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 1/21/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import GoogleMaps

class Path {
    var mutablePath: GMSMutablePath
    var polyLine: GMSPolyline
    
    init() {
        self.mutablePath = GMSMutablePath()
        self.polyLine = GMSPolyline()
    }
    
    func addCoordinate(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let coord = CLLocationCoordinate2DMake(lat, lng)
        self.mutablePath.add(coord)
    }
    
    func addCoordinate(coord: CLLocationCoordinate2D) {
        self.mutablePath.add(coord)
    }
    
    func removeCoordinate(at: UInt) {
        self.mutablePath.removeCoordinate(at: at)
    }
    
    func resetPath() {
        self.mutablePath.removeAllCoordinates()
    }
    
    func createPolyline() {
        self.polyLine = GMSPolyline(path: self.mutablePath)
        self.polyLine.strokeWidth = 8.0
        self.polyLine.strokeColor = .blue
    }
    
    func removePolyline() {
        self.polyLine.map = nil
    }
}
