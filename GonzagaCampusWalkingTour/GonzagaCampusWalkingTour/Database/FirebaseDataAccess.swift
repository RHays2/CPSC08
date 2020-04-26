//
//  FirebaseDataAccess.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/9/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import FirebaseDatabase

public class FirebaseDataAccess: DatabaseAccessible {
    static let TOURS_CHILD = "tours"
    static let ADMIN_ONLY_TOURS_CHILD = "admin_only_tour"
    static let NAME = "name"
    static let DESCRIPTION = "description"
    static let ADMIN_ONLY = "admin_only"
    static let LENGTH = "length"
    static let PREVIEW_IMAGE = "preview_image"
    
    static let STOPS_CHILD = "stops"
    static let LATTITUDE = "lat"
    static let LONGITUDE = "lng"
    static let STOP_ORDER = "stop_order"
    
    static let ASSETS_CHILD = "assets"
    static let STORAGE_NAME = "storage_name"
    
    var databaseReference: DatabaseReference?
    var storageReference: FirebaseStorageAccess
    
    init() {
        self.databaseReference = Database.database().reference()
        self.storageReference = FirebaseStorageAccess()
    }
    
    func getStopsForTour(id: String, callback: @escaping ([Stop]) -> Void) {
        if self.databaseReference != nil {
            //get all the tour stops under the tour id
            self.databaseReference?.child(FirebaseDataAccess.STOPS_CHILD).child(id).observeSingleEvent(of: .value, with: {(snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    var stops = [Stop]()
                    let keys = data.allKeys
                    //iterate through the keys
                    for (i,key) in keys.enumerated() {
                        if let stopDict = data[key] as? NSDictionary{
                            //get all the data from the dictionary
                            let stopId = key as? String ?? ""
                            let name = stopDict[FirebaseDataAccess.NAME] as? String ?? ""
                            let description = stopDict[FirebaseDataAccess.DESCRIPTION] as? String ?? ""
                            let lat = stopDict[FirebaseDataAccess.LATTITUDE] as? Double ?? 0.0
                            let lng = stopDict[FirebaseDataAccess.LONGITUDE] as? Double ?? 0.0
                            let order = stopDict[FirebaseDataAccess.STOP_ORDER] as? Int ?? i
                            
                            let stop = Stop(stopName: name, stopDescription: description, stopAssets: nil, stopLatitude: lat, stopLongitude: lng, order: order, id: stopId)
                            stops.append(stop)
                        }
                    }
                    //sort the stops by order
                    stops.sort(by: {s1, s2 in return s1.order < s2.order})
                    callback(stops)
                }
            })
        }
    }
    
    func getStopAssets(stopId: String, callback: @escaping ([Asset]) -> Void) {
        if self.databaseReference != nil {
            //get the stop asset ids from the database
            self.databaseReference?.child(FirebaseDataAccess.ASSETS_CHILD).child(stopId).observe(.value, with: {(snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    //create dispatch group to makesure we get all images for stops
                    let dispatchGroup = DispatchGroup()
                    var assets = [Asset]()
                    //iterate through all of the keys
                    for key in data.allKeys {
                        //cast the inner data as a dictionary
                        if let innerData = data[key] as? NSDictionary {
                            let name = innerData[FirebaseDataAccess.NAME] as? String ?? ""
                            let description = innerData[FirebaseDataAccess.DESCRIPTION] as? String ?? ""
                            let storage_name = innerData[FirebaseDataAccess.STORAGE_NAME] as? String ?? ""
                            let id = key as? String ?? ""
                            
                            //create the asset object
                            let asset = Asset(assetName: name, asset: nil, assetDescription: description, id: id)
                            
                            //get the image
                            if storage_name != "" {
                                dispatchGroup.enter()
                                self.storageReference.getImageNamed(name: storage_name, callback: {(image, error) in
                                    if image != nil {
                                        asset.asset = image
                                    }
                                    else { print(error ?? "") }
                                    dispatchGroup.leave()
                                })
                            }
                            assets.append(asset)
                        }
                    }
                    dispatchGroup.notify(queue: .main, execute: { ()
                        callback(assets)
                    })
                }
            })
        }
    }
    
    func locallyDownloadAssets(stopId: String, callback: @escaping ([Asset]) -> Void) {
        if self.databaseReference != nil {
            //get the stop asset ids from the database
            self.databaseReference?.child(FirebaseDataAccess.ASSETS_CHILD).child(stopId).observe(.value, with: {(snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    //create dispatch group to makesure we get all images for stops
                    let dispatchGroup = DispatchGroup()
                    var assets = [Asset]()
                    //iterate through all of the keys
                    for key in data.allKeys {
                        //cast the inner data as a dictionary
                        if let innerData = data[key] as? NSDictionary {
                            let name = innerData[FirebaseDataAccess.NAME] as? String ?? ""
                            let description = innerData[FirebaseDataAccess.DESCRIPTION] as? String ?? ""
                            let storage_name = innerData[FirebaseDataAccess.STORAGE_NAME] as? String ?? ""
                            let id = key as? String ?? ""
                            
                            //create the asset object
                            let asset = Asset(assetName: name, assetURL: nil, assetDescription: description, id: id)
                            //get the image URL
                            if storage_name != "" {
                                dispatchGroup.enter()
                                self.storageReference.downloadImageLocally(name: storage_name, id: stopId, callback: {(url, error) in
                                    if let localURL = url {
                                        asset.assetURL = localURL
                                    }
                                    else {
                                        //there was an error
                                        print(error ?? "")
                                    }
                                    dispatchGroup.leave()
                                })
                            }
                            //append the asset to the list
                            assets.append(asset)
                        }
                    }
                    dispatchGroup.notify(queue: .main, execute: { ()
                        callback(assets)
                    })
                }
                else { callback([]) }
            }) { (error) in
                print(error.localizedDescription)
                callback([])
            }
        }
    }
    
    func getTourInfoFrom(child: String, callback: @escaping ([TourInfo]?) -> Void) {
        //make sure we have a db reference
        if self.databaseReference != nil {
            //fetch all the data in the tours child
            self.databaseReference?.child(child).observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    //iterate through all the keys and create an array of Tours
                    var tours = [TourInfo]()
                    //create a dispatch group to make sure we get all preview images
                    let dispatchGroup = DispatchGroup()
                    
                    for key in data.allKeys {
                        //get the inner dictionary
                        if let innerData = data[key] as? NSDictionary {
                            let id = key as? String ?? ""
                            let name = innerData[FirebaseDataAccess.NAME] as? String ?? ""
                            let description = innerData[FirebaseDataAccess.DESCRIPTION] as? String ?? ""
                            let admin_only = innerData[FirebaseDataAccess.ADMIN_ONLY] as? Bool ?? false
                            let length = innerData[FirebaseDataAccess.LENGTH] as? Double ?? 0.0
                            let preview_img = innerData[FirebaseDataAccess.PREVIEW_IMAGE] as? String ?? ""
                            
                            //create a tour object and add it to the list
                            let tour = TourInfo(id: id, tourName: name, tourDescription: description, tourLength: length, adminOnly: admin_only, previewImagePath: preview_img)
                            
                            //attempt to get the preview image
                            dispatchGroup.enter()
                            var exit = false;
                            self.storageReference.getImageNamed(name: preview_img, callback: {(image, errorMsg) in
                                if image != nil {
                                  tour.previewImage = image
                                }
                                else {
                                    print(errorMsg ?? "")
                                }
                                //we have recieved a response, leave the dispatch group
                                if exit == false {
                                    dispatchGroup.leave()
                                    exit = true;
                                }
                            })
                            
                            tours.append(tour)
                        }
                    }
                    //send the tour information back to the caller
                    dispatchGroup.notify(queue: .main, execute: { ()
                        callback(tours)
                    })
                }
            }){ (error) in
                print(error.localizedDescription)
                callback(nil)
            }
        }
    }
    
    func getAllTourInfo(callback: @escaping ([TourInfo]) -> Void) {
        //attempt to get both admin tours and non admin tours
        //create a master list of tours
        var masterTourList:[TourInfo] = []
        //create a dispatch group to make sure you wait for both responses
        let dispatchGroup = DispatchGroup()
        //create a callback function for both calls to use
        func addToursToList(tours: [TourInfo]?) {
            if let tourList = tours {
                //add all of the returned tours to the list
                masterTourList.append(contentsOf: tourList)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        self.getTourInfoFrom(child: FirebaseDataAccess.TOURS_CHILD, callback: addToursToList(tours:))
        dispatchGroup.enter()
        self.getTourInfoFrom(child: FirebaseDataAccess.ADMIN_ONLY_TOURS_CHILD, callback: addToursToList(tours:))
        
        dispatchGroup.notify(queue: .main, execute: {
            callback(masterTourList)
        })
    }
    
    /*func getAllTourInfo(callback: @escaping ([TourInfo]) -> Void) {
        //make sure we have a db reference
        if self.databaseReference != nil {
            //fetch all the data in the tours child
            self.databaseReference?.child(FirebaseDataAccess.TOURS_CHILD).observeSingleEvent(of: .value, with: { (snapshot) in
                if let data = snapshot.value as? NSDictionary {
                    //iterate through all the keys and create an array of Tours
                    var tours = [TourInfo]()
                    //create a dispatch group to make sure we get all preview images
                    let dispatchGroup = DispatchGroup()
                    
                    for key in data.allKeys {
                        //get the inner dictionary
                        if let innerData = data[key] as? NSDictionary {
                            let id = key as? String ?? ""
                            let name = innerData[FirebaseDataAccess.NAME] as? String ?? ""
                            let description = innerData[FirebaseDataAccess.DESCRIPTION] as? String ?? ""
                            let admin_only = innerData[FirebaseDataAccess.ADMIN_ONLY] as? Bool ?? false
                            let length = innerData[FirebaseDataAccess.LENGTH] as? Double ?? 0.0
                            let preview_img = innerData[FirebaseDataAccess.PREVIEW_IMAGE] as? String ?? ""
                            
                            //create a tour object and add it to the list
                            let tour = TourInfo(id: id, tourName: name, tourDescription: description, tourLength: length, adminOnly: admin_only, previewImagePath: preview_img)
                            
                            //attempt to get the preview image
                            dispatchGroup.enter()
                            self.storageReference.getImageNamed(name: preview_img, callback: {(image, errorMsg) in
                                if image != nil {
                                  tour.previewImage = image
                                }
                                else {
                                    print(errorMsg ?? "")
                                }
                                //we have recieved a response, leave the dispatch group
                                dispatchGroup.leave()
                            })
                            
                            tours.append(tour)
                        }
                    }
                    //send the tour information back to the caller
                    dispatchGroup.notify(queue: .main, execute: { ()
                        callback(tours)
                    })
                }
            })
        }
    }*/
}
