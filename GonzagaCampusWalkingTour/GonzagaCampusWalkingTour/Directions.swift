//
//  Directions.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 1/22/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import MapKit

class Directions {
    static func getDirections(destinations: [CLLocationCoordinate2D], callback: @escaping ([CLLocationCoordinate2D]) -> Void) {
        if destinations.count >= 1 {
            var directionWaypoints: [CLLocationCoordinate2D] = []
            let dispatchGroup = DispatchGroup()
            
            for i in 0...destinations.count - 2 {
                dispatchGroup.enter()
                
                self.fetchDirections(pointA: destinations[i], pointB: destinations[i+1], travelType: MKDirectionsTransportType.walking, completionHandlerFunction: {(response, error) in
                    //add error handling
                    for step in response!.routes[0].steps {
                        directionWaypoints.append(step.polyline.coordinate)
                    }
                    dispatchGroup.leave()
                })
            }
            
            //notify must be called after all enteres and leaves!!!
            dispatchGroup.notify(queue: .main, execute: { ()
                callback(directionWaypoints)
            })
        }
    }
    
    static func getDirections(pointA:CLLocationCoordinate2D, pointB:CLLocationCoordinate2D, callback: @escaping (MKRoute) -> Void) {
        self.fetchDirections(pointA: pointA, pointB: pointB, travelType: MKDirectionsTransportType.walking, completionHandlerFunction: {(response, error) in
            guard let response = response else { return }
            if response.routes.count == 0 { return }
            callback(response.routes[0])
        })
    }
    
    
    private static func fetchDirections(pointA: CLLocationCoordinate2D, pointB: CLLocationCoordinate2D, travelType: MKDirectionsTransportType, completionHandlerFunction: @escaping MKDirections.DirectionsHandler) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: pointA))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: pointB))
        let request = MKDirections.Request()
        request.source = source
        request.destination = destination
        request.requestsAlternateRoutes = false
        request.transportType = travelType
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: completionHandlerFunction)
    }

}
