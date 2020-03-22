//
//  UserDefaultsProgressRetrieval.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/27/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation

class UserDefaultsProgressRetrieval: TourProgressRetrievable {
    var defaults: UserDefaults
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    func setStopAsVisited(tourId: String, stopId: String) {
        //check to see if the tour is has progress already
        /*if let tourProgress = self.defaults.object(forKey: tourId) as? TourProgress {
            
        }
        else {
            
        }*/
    }
    
    /***
        this function will return the tour progress associated with a tourId if it exists in the user defaults, if not it will return nil.
        if nil is returned, call the updateStopsInTour function
     */
    func getTourProgress(tourId: String) -> TourProgress? {
        guard let encoded = self.defaults.data(forKey: tourId) else { return nil }
        let decoder = JSONDecoder()
        var progress: TourProgress?
        do {
            progress = try decoder.decode(TourProgress.self, from: encoded)
        } catch (let error){
            print(error)
        }
        return progress
    }
    
    func saveTourProgress(progress: TourProgress, tourId: String) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(progress)
            defaults.set(encodedData, forKey: tourId)
        } catch {
            print("error storing tour progress")
        }
    }
    
    func resetTourProgress(progress: TourProgress) {
        //reset stop progress
        for key in progress.stopProgress.keys {
            progress.stopProgress[key] = false
        }
        //reset distance walked
        progress.distanceTraveled = 0.0
        //reset current stop
        progress.currentStop = 0
        //save the progress
        self.saveTourProgress(progress: progress, tourId: progress.id)
    }
    
    /**
        this function makes sure that the stops in the database match what is stored in the tour progress.
        if not we update the tourProgress.stopProgress to match the database
     */
    func updateStopsInTour(stops: [Stop], tourId: String) {
        //check to see if the tour is stored in defaults already
        if let tourProgress = getTourProgress(tourId: tourId) {
            //check for additions
            for stop in stops {
                //check if the stop id is in the TourProgress.stopProgress dictionary
                if tourProgress.stopProgress[stop.id] == nil {
                    //add the stop to the dictionary as not visited
                    tourProgress.stopProgress[stop.id] = false
                }
            }
            
            //check for stop deletions
            for key in tourProgress.stopProgress.keys {
                var inStops = false
                for stop in stops {
                    //this stop is still in the tour
                    if stop.id == key {
                        inStops = true
                    }
                }
                //if we did not find the id that was present in the stop progress in our tour stops retrieved from the DB
                // remove it
                if inStops  == false {
                    tourProgress.stopProgress.removeValue(forKey: key)
                }
            }
            self.saveTourProgress(progress: tourProgress, tourId: tourId)
        }
        else {
            //the tour was not found in the user defaults
            var stopProgress = [String:Bool]()
            for stop in stops {
                //add each stop to the stopProgress
                stopProgress[stop.id] = false
            }
            let tourProgress = TourProgress(id: tourId, distanceTravled: 0.0, stopProgress: stopProgress, currentStop: 0)
            //save the progress
            self.saveTourProgress(progress: tourProgress, tourId: tourId)
        }
    }
}
