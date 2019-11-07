//
//  GoogleMapsViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 10/25/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController,CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom:0))
    let CAMERA_ANGLE = 45.0;
    var currentDirection = CLLocationDirection()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // check to make sure the user has location enabled
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            setupLocationServices()
            setUpMapView()
        }
        else {
            // the user turned off location, phone is airplane mode, lack of hardware, hardware failure,...
            print("Location services disabled")
        }
        
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 47.667533, longitude: -117.400630)
//        marker.title = "Gonzaga University"
//        marker.snippet = "Test Location"
//        marker.map = mapView
    }
    
    func centerUserLocationOnMap(location: CLLocation) {
        // Create a GMSCameraPosition that tells the map to display the
        // centered around the users location
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 18.0, bearing: self.currentDirection, viewingAngle: CAMERA_ANGLE)
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
        locationManager.requestWhenInUseAuthorization()
        //begin getting the location and heading
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading();
    }
    
    func setUpMapView() {
        //enable locations on map
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        //change map type to be hybrid (satellite with labels)
        mapView.mapType = GMSMapViewType.hybrid
        //add layout constraints
        view.addSubviewAndPinEdges(mapView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //move map to center around user
        self.centerUserLocationOnMap(location: locations.last ?? CLLocation())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.orientMapTowardUserHeading(direction: newHeading.magneticHeading)
    }
}

