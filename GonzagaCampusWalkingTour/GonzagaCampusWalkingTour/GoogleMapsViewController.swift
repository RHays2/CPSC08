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
    var userInRegion: Bool = false
    var distanceTracker: DistanceTracker?
    var notificationCenter: LocationNotificationCenter = LocationNotificationCenter()
    
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
            print("Location services enabled for device")
            setupLocationServices()
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    self.notificationCenter.requestLocationNotificationPermissions(callback: { (granted) in
                        if granted { print("notifications granted") } else { print("notifications denied") }
                    })
                    startLocationServices()
                    setUpMapView()
                    addProgressLabel()
                    setupMapWithTourStops()
                    break
                case .restricted, .denied:
                    displayLocationsNeededAlert()
                    break
                case .notDetermined:
                    break
            }
        }
        else {
            // the user turned off location, phone is airplane mode, lack of hardware, hardware failure,...
            print("Location services disabled")
            displayLocationsNeededAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //determine if the locations ervices are enabled for the application
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            self.notificationCenter.requestLocationNotificationPermissions(callback: { (granted) in
                if granted { print("notifications granted") } else { print("notifications denied") }
            })
            startLocationServices()
            setUpMapView()
            addProgressLabel()
            setupMapWithTourStops()
            break
        case .restricted, .denied:
            displayLocationsNeededAlert()
            break
        case .notDetermined:
            break
            
        }
    }
    
    func displayLocationsNeededAlert() {
        let alertMsg = "Without location services, we cannot help you navigate around campus. Please go into settings and allow location tracking for this app."
        let alert = UIAlertController(title: "Location Services Required", message: alertMsg, preferredStyle: .alert)
        //create an action for a cancel button
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(alertAction) in
            //exit this screen
            if let nav = self.navigationController {
                nav.popToRootViewController(animated: true)
            }
        })
        
        alert.addAction(okAction)
        //present alert dialog
        self.present(alert, animated: true, completion: nil)
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
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        // requests users location always
        locationManager.requestAlwaysAuthorization()
    }
    
    func startLocationServices() {
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
        
        //determine if the user has entered a region
        if self.isUserInCurrentRegion() {
            if self.userInRegion == false {
                //alert the user they have just entered the region
                if self.notificationCenter.notificationsPermissions {
                    self.notificationCenter.sendNotification(title: "Entering Tour Stop", body: "You are now close enough to a stop to visit it!")
                }
            }
        }
        self.userInRegion = self.isUserInCurrentRegion()
        
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
                    if self.notificationCenter.notificationsPermissions {
                        self.notificationCenter.sendNotification(title: "Entering Tour Stop", body: "You are now close enough to a stop to visit it!")
                    }
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //TODO: make sure user is accessing stops in order
        if let stop = marker as? Stop {
            guard let progress = self.tourProgress else { return false }
            guard let tourInfo = self.activeTour else { return false }
            //determine if the user is within the region of the stop and if this is the stop that they are one
            //or if this stop is already visited
            if (/*stop.isInCloseProximity == true*/self.isUserInCurrentRegion() && progress.currentStop == stop.order - 1)  || progress.stopProgress[stop.id] == true {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                //create the tabBarController
                if let tabBarController = storyBoard.instantiateViewController(withIdentifier: "StopViewTabBarController") as? StopViewTabBarController{
                    tabBarController.curStop = stop
                    tabBarController.databaseReference = self.databaseReference
                    tabBarController.modalPresentationStyle = .pageSheet
                    //show the new tabViewController
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    
                    //draw the route to the next stop
                    if progress.currentStop == stop.order - 1 {
                        progress.currentStop += 1
                        //update tour progress
                        progress.stopProgress[stop.id] = true
                        //update the progress label
                        self.setProgressLabel()
                        if tourInfo.tourStops.count == progress.currentStop {
                            //this is the last tour stop
                            //make sure that the tour has not alread been completed
                            if progress.tourCompleted == false  {
                                progress.tourCompleted = true
                                progress.dateCompleted = Date().toString(format: "MMMM d, yyyy")
                                //display alert dialog congratulating user on completing the tour
                                displayTourCompletedAlertDialog()
                                //clear the path
                                self.path.removePolyline()
                            }
                        }
                        else {
                            self.addDirectionsPath()
                        }
                    }
                    
                    return true
                }
            }
            else {
                if progress.currentStop != stop.order - 1 {
                    //trying to visit a stop they are not on
                    //display message saying they need to visit stops in order
                    self.displayVisitStopsInOrderAlertDialog()
                }
                else {
                    //display message that you are not close enough to visit this stop
                    self.displayOutOfRangeAlertDialog()
                }
            }
        }
        return false
    }
    
    func displayVisitStopsInOrderAlertDialog() {
        let curStop = (self.tourProgress?.currentStop ?? 1) + 1
        let alertMsg = "Please visit the stops in order. You are currently on stop number \(curStop)."
        let alert = UIAlertController(title: "Stop Visited Out of Order", message: alertMsg, preferredStyle: .alert)
        //create an action for a cancel button
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        //present alert dialog
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayTourCompletedAlertDialog() {
        let alertMsg = "Congratulations! You have completed this tour. You can restart your tour progress by visiting the settings page accessible by the \"settings\" button on the map page. You can also view your all of your other tour progress on the Stats page accessible by home page."
        let alert = UIAlertController(title: "Tour Completed", message: alertMsg, preferredStyle: .alert)
        //create an action for a cancel button
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(okAction)
        //present alert dialog
        self.present(alert, animated: true, completion: nil)
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
                    self.createMonitoredRegion(center: CLLocationCoordinate2D(latitude: stops[curStop].stopLatitude, longitude: stops[curStop].stopLongitude), radius: 15, id: String(curStop))
                    //determine if user is in the region
                    self.isUserInRegion()
                }
            }
        }
    }
    
    func isUserInCurrentRegion() -> Bool {
        if let reg = self.currentMonitoredRegion {
            if reg.contains(self.currentLocation.coordinate) {
                return true
            }
        }
        return false
    }
    
    func isUserInRegion() {
        if let reg = self.currentMonitoredRegion {
            if reg.contains(self.currentLocation.coordinate) {
                if self.activeTour?.tourStops != nil {
                    if let index = Int(reg.identifier), index < self.activeTour?.tourStops.count ?? 0 {
                        //set the stops isInProximity to true
                        self.activeTour?.tourStops[index].isInCloseProximity = true
                        /*if self.notificationCenter.notificationsPermissions {
                            self.notificationCenter.sendNotification(title: "Entering Tour Stop", body: "You are now close enough to a stop to visit it!")
                        }*/
                    }
                }
            } else {
                if self.activeTour?.tourStops != nil {
                    if let index = Int(reg.identifier), index < self.activeTour?.tourStops.count ?? 0 {
                        //set the stops isInProximity to true
                        self.activeTour?.tourStops[index].isInCloseProximity = false
                    }
                }
            }
        }
        
    }
}

