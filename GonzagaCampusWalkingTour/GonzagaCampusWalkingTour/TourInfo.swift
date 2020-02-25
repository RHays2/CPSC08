//
//  TourInfo.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/10/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import UIKit

class TourInfo {
    var id: String
    var tourName: String
    var tourDescription: String
    var tourLength: Double
    var adminOnly: Bool
    var previewImagePath: String
    var previewImage: UIImage?
    var tourStops: [Stop]
    
    init(id: String, tourName: String, tourDescription: String, tourLength: Double, adminOnly: Bool, previewImagePath: String) {
        self.id = id
        self.tourName = tourName
        self.tourDescription = tourDescription
        self.tourLength = tourLength
        self.adminOnly = adminOnly
        self.previewImagePath = previewImagePath
        self.tourStops = [Stop]()
    }
}
