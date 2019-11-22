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
    let locationManager = CLLocationManager()
    var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom:0))
    let CAMERA_ANGLE = 45.0;
    var currentDirection = CLLocationDirection()
    var currentLocation = CLLocation()
    var activeTour:Tour?
    
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
        
        // will setup tour stops for the selected tour
        if activeTour != nil {
            createMarkersForTourStops(tour: activeTour!)
        } else {
            print("Failed to pass selected tour")
            setStopsTemp() // otherwise set up default markers
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TourStopViewController {
            destination.currentStop = self.mapView.selectedMarker as? Stop
        }
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
        mapView.delegate = self
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let stop = marker as? Stop {
            let tourStopViewController = TourStopViewController(nibName: nil, bundle: nil)
            //tourStopViewController.modalPresentationStyle = .fullScreen
            tourStopViewController.currentStop = stop
            self.present(tourStopViewController, animated: true, completion: nil)
            return true
        }
        return false
    }

    func createMarkersForTourStops(tour: Tour) {
        for stop in tour.tourStops {
            stop.map = self.mapView
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

