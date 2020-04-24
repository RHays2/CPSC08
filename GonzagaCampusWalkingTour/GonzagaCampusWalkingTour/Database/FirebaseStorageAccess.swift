//
//  FirebaseStorageAccess.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 2/12/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageAccess {
    static let IMAGES_PATH = "images/"
    var storage: Storage?
    var storageRef: StorageReference?
    var imagesRef: StorageReference?
    
    init() {
        self.storage = Storage.storage()
        self.storageRef = self.storage?.reference()
        self.imagesRef = self.storageRef?.child(FirebaseStorageAccess.IMAGES_PATH)
    }
    
    func getImageNamed(name: String, callback: @escaping (UIImage?, String?) -> Void) {
        if self.imagesRef != nil {
            let curImage = self.imagesRef?.child(name)
            //download image with a max size of 3 megabite
            curImage?.getData(maxSize: 3 * 1024 * 1024, completion: {(data, error) in
                if data != nil {
                    guard let unwrapped = data else {return}
                    let image = UIImage(data: unwrapped)
                    callback(image, nil)
                }
                else {
                    let msg = "ERROR: Unable to get image of path: \(String(describing: curImage?.fullPath))"
                    print(msg)
                    //print(error!)
                    callback(nil, msg)
                }
            })
        }
    }
    
    func downloadImageLocally(name: String, id: String, callback: @escaping(String?, String?) -> Void) {
        //create a URL to a local file in the apps tmp directory
        let tempDir = FileManager.default.temporaryDirectory
        let localURL = tempDir.appendingPathComponent(id + "_" + name)
        
        //check to see if the image is already downloaded
        if FileManager.default.fileExists(atPath: localURL.path) {
            //return the path and id to the callback function
            callback(localURL.absoluteString, nil)
        }
        //the file does not already exist
        else if self.imagesRef != nil {

            let curImageRef = self.imagesRef?.child(name)
            //write the image URL
            curImageRef?.write(toFile: localURL, completion: {(url,error) in
                if let imageURL = url {
                    //return the path and id to the callback function
                    callback(imageURL.absoluteString, nil)
                }
                else {
                    if let e = error {
                        print(e)
                        callback(nil, e.localizedDescription)
                    }
                }
            })
        }
    }
}
