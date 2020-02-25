//
//  DatabaseProtocol.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/9/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation

protocol DatabaseAccessible {
    func getStopsForTour(id: String, callback: @escaping ([Stop]) -> Void)
    func getAllTourInfo(callback: @escaping ([TourInfo]) -> Void)
    func getStopAssets(stopId: String, callback: @escaping ([Asset]) -> Void)
}
