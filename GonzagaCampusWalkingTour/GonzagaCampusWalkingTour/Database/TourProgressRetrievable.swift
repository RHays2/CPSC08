//
//  TourProgressRetrievable.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/27/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation

protocol TourProgressRetrievable {
    func setStopAsVisited(tourId: String, stopId: String)
    /**
       this function makes sure that the stops in the database match what is stored in the tour progress.
       if not we update the tourProgress.stopProgress to match the database
    */
    func updateStopsInTour(stops: [Stop], tourId: String)
    /***
        this function will return the tour progress associated with a tourId if it exists in the user defaults, if not it will return nil.
        if nil is returned, call the updateStopsInTour function
     */
    func getTourProgress(tourId: String) -> TourProgress?
    
    /***
        this function saves all tour progress 
     */
    func saveTourProgress(progress: TourProgress, tourId: String)
    /**
        this function resets the tour progress for the given tour
     **/
    func resetTourProgress(progress: TourProgress)
}
