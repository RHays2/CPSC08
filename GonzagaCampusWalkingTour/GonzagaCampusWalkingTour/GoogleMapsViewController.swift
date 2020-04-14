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

class GoogleMapsViewController: UIViewController,CLLocationManagerDelegate, GMSMapViewDelegate, UIApplicationDelegate{
    static let CAMERA_ANGLE = 45.0
    static let DEFAULT_ZOOM: Float = 19.0
    
    var settingsButton: UIBarButtonItem = UIBarButtonItem()
    
    var databaseReference: DatabaseAccessible?
    let locationManager = CLLocationManager()
    var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: DEFAULT_ZOOM))
    var currentDirection = CLLocationDirection()
    var currentLocation = CLLocation()
    var active:Tour?
    var activeTour: TourInfo?
    let path = Path()
    var tourStopCounter = 0
    var currentZoom: Float = DEFAULT_ZOOM
    var centerOnUser = true
    var waypointCounter = 0
    var tourProgress: TourProgress?
    var tourProgressRetriever: TourProgressRetrievable = UserDefaultsProgressRetrieval()
    var currentMonitoredRegion: CLCircularRegion?
    var distanceTracker: DistanceTracker?
    
    var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsButtonSetup()
        // Do any additional setup after loading the view.
        // check to make sure the user has location enabled
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            setupLocationServices()
            setUpMapView()
            addProgressLabel()
            setupMapWithTourStops()
        }
        else {
            // the user turned off location, phone is airplane mode, lack of hardware, hardware failure,...
            print("Location services disabled")
        }
    }
    
    func settingsButtonSetup() {
        self.settingsButton = addSettingsButtonToNavBar()
        self.settingsButton.action = #selector(settingsPressed)
    }
    
    @objc func settingsPressed() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //instatiate Settings view controller
        if let vc = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            if let progress = self.tourProgress {
                vc.tourProgress = progress
            }
            vc.tourProgressRetriever = self.tourProgressRetriever
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //make sure to save a users progress when the application is about to exit
        print("did enter background")
        saveProgress()
        //delete all images from the tmp file directory
        FileManager.default.clearTmpDirectory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //make sure to save a users progress when the application is about to exit
        print("will disappear")
        saveProgress()
        //check if this viewCOntroller is being popped from navigation
        if self.isMovingFromParentViewController {
            //delete all images from the tmp file directory
            FileManager.default.clearTmpDirectory()
        }
    }
    
    func saveProgress() {
        guard let tour = self.activeTour else {return}
        guard let progress = self.tourProgress else {return}
        if let dist = self.distanceTracker {
            progress.distanceTraveled = dist.currentDistance
        }
        self.tourProgressRetriever.saveTourProgress(progress: progress, tourId: tour.id)
    }
    
    func setUpTourProgress() {
        guard let tour = activeTour else {return}
        //update the tour progress stops because their may be a change from the database
        tourProgressRetriever.updateStopsInTour(stops: tour.tourStops, tourId: tour.id)
        if let progress = tourProgressRetriever.getTourProgress(tourId: tour.id) {
            self.tourProgress = progress
            updateMonitoredRegion()
            //initialize distance tracker
            self.distanceTracker = DistanceTracker(initialDistance: progress.distanceTraveled)
        }
    }
    
    func addProgressLabel() {
        self.view.addSubview(self.progressLabel)
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.progressLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 5),
            self.progressLabel.rightAnchor.constraint(equalTo: safeAreaGuide.rightAnchor, constant: -5),
            self.progressLabel.widthAnchor.constraint(equalToConstant: 150),
            self.progressLabel.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    func setProgressLabel() {
        let numStops = self.activeTour?.tourStops.count ?? 0
        let text = "\(self.tourProgress?.currentStop ?? 0)/\(numStops) Stops"
        self.progressLabel.text = text
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
        locationManager.startUpdatingHeading()
    }
    
    func setupMapWithTourStops() {
        // will setup tour stops for the selected tour
        if let tour = activeTour {
            //get the stops from the database
            let indicator = self.createCenteredProgressIndicator()
            self.view.addSubview(indicator)
            indicator.startAnimating()
            databaseReference?.getStopsForTour(id: tour.id, callback: {(stops) in
                //we have recieved the stops in sorted order
                tour.tourStops = stops
                self.setUpTourProgress()
                self.createMarkersForTourStops(tour: tour)
                self.setProgressLabel()
                indicator.stopAnimating()
                self.addDirectionsPath()
            })
            
        } else {
            print("Failed to pass selected tour")
            setStopsTemp() // otherwise set up default markers
        }
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
            if stops.count > 0 && self.tourProgress?.currentStop ?? 0 < stops.count {
                destination = CLLocation(latitude: stops[self.tourProgress?.currentStop ?? 0].stopLatitude, longitude: stops[self.tourProgress?.currentStop ?? 0].stopLongitude)
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
                    for coord in coordinates {
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
        if let location = locations.last {
            //if the initial location of distance tracker is nil, add it as the initial
            if self.distanceTracker != nil {
                if self.distanceTracker?.currentPosition == nil {
                    //init the starting postion
                    self.distanceTracker?.currentPosition = location
                }
                else {
                    //we have an initial location, we need to update the current location
                    self.distanceTracker?.updateCurrentPosition(newPosition: location)
                }
            }
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
        if self.activeTour != nil && self.activeTour?.tourStops != nil {
            if let index = Int(region.identifier) {
                if index < self.activeTour?.tourStops.count ?? 0 {
                    //we are close enough to the stop that a user can visit it
                    self.activeTour?.tourStops[index].isInCloseProximity = true
                    //alert the user that they have entered a stop area
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        //this function will run when a user exits the region of a tour stop
        if self.activeTour != nil && self.activeTour?.tourStops != nil {
            if let index = Int(region.identifier) {
                if index < self.activeTour?.tourStops.count ?? 0 {
                    //we left the area close that contains the stop
                    self.activeTour?.tourStops[index].isInCloseProximity = false
                }
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //TODO: make sure user is accessing stops in order
        if let stop = marker as? Stop {
            guard let progress = self.tourProgress else { return false }
            //determine if the user is within the region of the stop and if this is the stop that they are one
            //or if this stop is already visited
            if (stop.isInCloseProximity == true && progress.currentStop == stop.order - 1)  || progress.stopProgress[stop.id] == true {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //create the tabBarController
                if let tabBarController = storyBoard.instantiateViewController(withIdentifier: "StopViewTabBarController") as? StopViewTabBarController{
                    tabBarController.curStop = stop
                    tabBarController.databaseReference = self.databaseReference
                    tabBarController.modalPresentationStyle = .pageSheet
                    //show the new tabViewController
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    
                    //draw the route to the next stop
                    if self.tourProgress?.currentStop ?? 0 == stop.order - 1 {
                        if let progress = self.tourProgress {
                            progress.currentStop += 1
                        }
                        //update tour progress
                        if self.tourProgress != nil {
                            self.tourProgress?.stopProgress[stop.id] = true
                        }
                        self.setProgressLabel()
                        self.addDirectionsPath()
                    }
                    
                    return true
                }
            }
            else {
                //display message that you are not close enough to visit this stop
                self.displayOutOfRangeAlertDialog()
            }
        }
        return false
    }
    
    func displayOutOfRangeAlertDialog() {
        let alertMsg = "You cannot visit this tour stop because you are out of range. Please walk toward the stop, and when you are close enough you can visit it!"
        let alert = UIAlertController(title: "Out of Range", message: alertMsg, preferredStyle: .alert)
        //create an action for a cancel button
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        //present alert dialog
        self.present(alert, animated: true, completion: nil)
    }

    func createMarkersForTourStops(tour: TourInfo) {
        for i in 0 ..< tour.tourStops.count {
            let stop = tour.tourStops[i]
            stop.map = self.mapView
        }
    }
    
    func createMonitoredRegion(center: CLLocationCoordinate2D, radius: Double, id: String) {
        let region = CLCircularRegion(center: center, radius: radius, identifier: id)
        self.locationManager.startMonitoring(for: region)
        self.currentMonitoredRegion = region
    }
    
    func updateMonitoredRegion() {
        if self.tourProgress != nil && self.activeTour?.tourStops != nil {
            if let curStop = self.tourProgress?.currentStop, let stops = self.activeTour?.tourStops {
                if curStop < stops.count {
                    //stop monitoring old region
                    if let reg = self.currentMonitoredRegion {
                        if self.locationManager.monitoredRegions.contains(reg) {
                            self.locationManager.stopMonitoring(for: reg)
                        }
                    }
                    //create a monitored region for the current stop
                    self.createMonitoredRegion(center: CLLocationCoordinate2D(latitude: stops[curStop].stopLatitude, longitude: stops[curStop].stopLongitude), radius: 30, id: String(curStop))
                    //determine if user is in the region
                    self.isUserInRegion()
                }
            }
        }
    }
    
    func isUserInRegion() {
        if let reg = self.currentMonitoredRegion {
            if reg.contains(self.currentLocation.coordinate) {
                if self.activeTour?.tourStops != nil {
                    if let index = Int(reg.identifier), index < self.activeTour?.tourStops.count ?? 0 {
                        //set the stops isInProximity to true
                        self.activeTour?.tourStops[index].isInCloseProximity = true
                    }
                }
            }
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

