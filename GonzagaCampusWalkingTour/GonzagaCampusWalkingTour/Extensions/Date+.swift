//
//  Date+.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/14/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
