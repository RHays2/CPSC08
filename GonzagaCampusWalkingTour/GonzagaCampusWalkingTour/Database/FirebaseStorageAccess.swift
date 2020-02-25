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
            //download image with a max size of 1 megabite
            curImage?.getData(maxSize: 1 * 1024 * 1024, completion: {(data, error) in
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
}
