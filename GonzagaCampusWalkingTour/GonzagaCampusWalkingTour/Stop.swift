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
    var stopAssets: [Asset]?
    var stopLatitude: Double
    var stopLongitude: Double
    var order: Int
    var id: String
    
    
    
    //MARK: Initialization
    init(stopName: String, stopDescription: String, stopAssets: [Asset]?, stopLatitude: Double, stopLongitude: Double, order: Int, id: String) {    
        self.stopName = stopName
        self.stopDescription = stopDescription
        self.stopAssets = stopAssets
        self.stopLatitude = stopLatitude
        self.stopLongitude = stopLongitude
        self.order = order
        self.id = id
        
        super.init()
        self.position = CLLocationCoordinate2D(latitude: stopLatitude, longitude: stopLongitude)
        if order > 0 && order <= 30 {
            let image = UIImage(named: "BWR\(order)")
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
            self.iconView = imageView
        }
        else {
            self.icon = UIImage(named: "question")
        }
    }
    
}

