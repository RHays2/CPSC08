//
//  FileManager+.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/2/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    func getImageFromTemporaryDir(name: String) -> UIImage? {
        //create URL to the image
        let tempDir = FileManager.default.temporaryDirectory
        let localURL = tempDir.appendingPathComponent(name)

        //make sure the file actually exists in the temporary dir
        if FileManager.default.fileExists(atPath: localURL.path) {
            return UIImage(contentsOfFile: localURL.path)
        }
        return nil
    }
    
    func getImageFromPath(urlStr: String) -> UIImage? {
        //make sure the file actually exists in the temporary dir
        if let url = URL(string: urlStr) {
            if FileManager.default.fileExists(atPath: url.path) {
                return UIImage(contentsOfFile: url.path)
            }
        }
        return nil
    }
    
    func clearTmpDirectory() {
        do {
            let tmpContents = try self.contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpContents.forEach({(file) in
                try self.removeItem(at: FileManager.default.temporaryDirectory.appendingPathComponent(file))
            })
        } catch {
            print(error)
        }
    }
}
