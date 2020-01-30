//
//  GoogleMapsViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 10/25/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//Icons made by <a href="https://www.flaticon.com/authors/smashicons" title="Smashicons">Smashicons</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com
//
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate{
    static let CAMERA_ANGLE = 45.0
    static let DEFAULT_ZOOM: Float = 19.0
    
    let locationManager = CLLocationManager()
    var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: DEFAULT_ZOOM))
    var currentDirection = CLLocationDirection()
    var currentLocation = CLLocation()
    var activeTour:Tour?
    let path = Path()
    var tourStopCounter = 0
    var currentZoom: Float = DEFAULT_ZOOM
    var centerOnUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // check to make sure the user has location enabled
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            setupLocationServices()
            setUpMapView()
            addDirectionsPath()
        }
        else {
            // the user turned off location, phone is airplane mode, lack of hardware, hardware failure,...
            print("Location services disabled")
        }
        
        // will setup tour stops for the selected tour
        if activeTour != nil {
            createMarkersForTourStops(tour: activeTour!)
        } else {
            print("Failed to pass selected tour")
            setStopsTemp() // otherwise set up default markers
        }
    }
    
    func centerUserLocationOnMap(location: CLLocation) {
        // Create a GMSCameraPosition that tells the map to display the
        // centered around the users location
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: self.currentZoom, bearing: self.currentDirection, viewingAngle: GoogleMapsViewController.CAMERA_ANGLE)
        mapView.animate(to: camera)
        //update current location var
        self.currentLocation = location
    }
    
    func orientMapTowardUserHeading(direction: CLLocationDirection) {
        //orient the map in the direction the user is facing
        mapView.animate(toBearing: direction)
        //update current direction
        self.currentDirection = direction
    }
    
    func setupLocationServices() {
        locationManager.delegate = self
        // shows the users location as accurate as possible. Will be battery intensive
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        // requests users location only when the app is in use
        //locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        //begin getting the location and heading
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading();
    }
    
    func setUpMapView() {
        //enable locations on map
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        //change map type to be hybrid (satellite with labels)
        mapView.mapType = GMSMapViewType.satellite
        mapView.delegate = self
        //add layout constraints
        view.addSubviewAndPinEdges(mapView)
    }
    
    func addDirectionsPath() {
        if let stops = self.activeTour?.tourStops {
            guard let myLocation = self.locationManager.location else { return }
            var destination = CLLocation()
            if stops.count > 0 && self.tourStopCounter < stops.count {
                destination = CLLocation(latitude: stops[self.tourStopCounter].stopLatitude, longitude: stops[self.tourStopCounter].stopLongitude)
            } else { return }
            
            self.path.removePolyline()
            self.path.resetPath()
            
            //determine the distance between the 2 points
            let distance = myLocation.distance(from: destination)
            if distance.isLess(than: 60.0) {
                self.path.addCoordinate(coord: myLocation.coordinate)
                self.path.addCoordinate(coord: destination.coordinate)
                self.path.createPolyline()
                self.path.polyLine.map = self.mapView
                
            } else {
                //get directions
                Directions.getDirections(pointA: myLocation.coordinate, pointB: destination.coordinate, callback: {(coordinates) in
                    //this function is called when all the waypoints are recieved
                    self.path.addCoordinate(coord: myLocation.coordinate)
                    for coord in coordinates{
                        self.path.addCoordinate(coord: coord)
                    }
                    self.path.addCoordinate(coord: destination.coordinate)
                    self.path.createPolyline()
                    self.path.polyLine.map = self.mapView
                })
            }
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //move map to center around user if centerOnUser == true
        if (self.centerOnUser == true) {
          self.centerUserLocationOnMap(location: locations.last ?? CLLocation())
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        //orient map to direction of user if centerOnUser == true
        if (self.centerOnUser == true) {
            self.orientMapTowardUserHeading(direction: newHeading.magneticHeading)
        }
    }

    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // if the user manually attempts to change location by dragging
        // gesture will be true
        if (gesture == true) {
            self.centerOnUser = false
        }
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        //method called when user presses the MyLocationButton
        //user wants to have map centered around their location once again
        self.centerOnUser = true
        self.currentZoom = GoogleMapsViewController.DEFAULT_ZOOM
        self.centerUserLocationOnMap(location: self.currentLocation)
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        //this function will run when user enters the region of a tour stop
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //make sure user is accessing stops in order
        if let stop = marker as? Stop {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //create the tabBarController
            if let tabBarController = storyBoard.instantiateViewController(withIdentifier: "StopViewTabBarController") as? StopViewTabBarController{
                tabBarController.curStop = stop
                tabBarController.modalPresentationStyle = .pageSheet
                //show the new tabViewController
                self.navigationController?.pushViewController(tabBarController, animated: true)
                
                //draw the route to the next stop
                if self.tourStopCounter == stop.order - 1 {
                    self.tourStopCounter += 1
                    self.addDirectionsPath()
                }
                
                return true
            }
        }
        return false
    }

    func createMarkersForTourStops(tour: Tour) {
        for i in 0 ..< tour.tourStops.count {
            let stop = tour.tourStops[i]
            stop.map = self.mapView
            let center = CLLocationCoordinate2D(latitude: stop.stopLatitude, longitude: stop.stopLongitude)
            let region = CLCircularRegion(center: center, radius: 30, identifier: "\(i)")
            self.locationManager.startMonitoring(for: region)
        }
    }
    
    /*func createMarkerForStop(currentStop: Stop) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: currentStop.stopLatitude, longitude: currentStop.stopLongitude)
        marker.title = currentStop.stopName
        marker.snippet = currentStop.stopDescription ?? currentStop.stopName // snippet is the description; if that doesn't exist use the name again
        marker.map = mapView
        marker.icon = UIImage(named: "question")
        marker.isFlat = true;
    }*/

    
    
    //a temporary function for displaying several markers before tour data is loaded from database
    // when data is passed from the tours, we can set the marker information as needed
    func setStopsTemp(){
        // Creates a marker at hemmingson.
        let hemmingson = GMSMarker()
        hemmingson.position = CLLocationCoordinate2D(latitude: 47.667241, longitude: -117.399307)
        hemmingson.title = "Hemmingson"
        hemmingson.snippet = "The student center of gonzaga"
        hemmingson.map = mapView
        hemmingson.icon = UIImage(named: "question")
        hemmingson.isFlat = true;
        
        // Creates a marker at desmet.
        let desmet = GMSMarker()
        desmet.position = CLLocationCoordinate2D(latitude: 47.667843, longitude: -117.401104)
        desmet.title = "Desmet"
        desmet.snippet = "The first dorm on campus"
        desmet.map = mapView
        desmet.icon = UIImage(named: "question")
        desmet.isFlat = true;
        
        // Creates a marker at college hall.
        let collegeHall = GMSMarker()
        collegeHall.position = CLLocationCoordinate2D(latitude: 47.668112, longitude: -117.402269)
        collegeHall.title = "College Hall"
        collegeHall.snippet = "The main campus building for Gonzaga classes in arts and sciences"
        collegeHall.map = mapView
        collegeHall.icon = UIImage(named: "question")
        collegeHall.isFlat = true;
        
        // Creates a marker at foley.
        let foley = GMSMarker()
        foley.position = CLLocationCoordinate2D(latitude: 47.666471, longitude: -117.400589)
        foley.title = "Foley Librar"
        foley.snippet = "The Library"
        foley.map = mapView
        foley.icon = UIImage(named: "question")
        foley.isFlat = true;
        
        // Creates a marker at paccar.
        let paccar = GMSMarker()
        paccar.position = CLLocationCoordinate2D(latitude: 47.666308, longitude: -117.402112)
        paccar.title = "Paccar"
        paccar.snippet = "An engineering building"
        paccar.map = mapView
        paccar.icon = UIImage(named: "question")
        paccar.isFlat = true;
        
        // Creates a marker at luger field.
        let luger = GMSMarker()
        luger.position = CLLocationCoordinate2D(latitude: 47.665272, longitude: -117.401973)
        luger.title = "Luger"
        luger.snippet = "A field where soccer is played"
        luger.map = mapView
        luger.icon = UIImage(named: "question")
        luger.isFlat = true;
        
        // Creates a marker at the parking garage.
        let parking = GMSMarker()
        parking.position = CLLocationCoordinate2D(latitude: 47.667967, longitude: -117.397236)
        parking.title = "Parking"
        parking.snippet = "You can put your car here"
        parking.map = mapView
        parking.icon = UIImage(named: "question")
        parking.isFlat = true;
        
        // Creates a marker at rosaur.
        let rosauer = GMSMarker()
        rosauer.position = CLLocationCoordinate2D(latitude: 47.668136, longitude: -117.399140)
        rosauer.title = "Rosauer"
        rosauer.snippet = "The education building"
        rosauer.map = mapView
        rosauer.icon = UIImage(named: "question")
        rosauer.isFlat = true;
        
        // Creates a marker at coughlin.
        let coughlin = GMSMarker()
        coughlin.position = CLLocationCoordinate2D(latitude: 47.664874, longitude: -117.397150)
        coughlin.title = "Coughlin"
        coughlin.snippet = "The nicest dorms on campus"
        coughlin.map = mapView
        coughlin.icon = UIImage(named: "question")
        coughlin.isFlat = true;
        
        // Creates a marker at jundt.
        let jundt = GMSMarker()
        jundt.position = CLLocationCoordinate2D(latitude: 47.666313, longitude: -117.406938)
        jundt.title = "Jundt"
        jundt.snippet = "The art museum"
        jundt.map = mapView
        jundt.icon = UIImage(named: "question")
        jundt.isFlat = true;
    }
}

