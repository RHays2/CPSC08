//
//  TourStopViewController.swift
//  GonzagaCampusWalkingTour
//
//  Created by Hays, Ryan T on 11/21/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit
import SwiftSoup

class TourStopViewController: UIViewController {
    var currentStop: Stop?
    var databaseReference: DatabaseAccessible?
    @IBOutlet weak var stopName: UILabel!
    @IBOutlet weak var stopDescription:UITextView!
    
    var openingHtml: String = ""
    var closingHtml: String = ""
    var middleHtml: String = ""
    
    override func viewDidLoad() {
        //initalize the html member variables.
        //the stop description html will be displayed between
        //openingHtml and closingHtml
        self.openingHtml = "<html>"
                            + "<head>"
                                + "<style>"
                                    + "img { "
                                        + "width: \(self.view.frame.size.width);"
                                        + "display: block;"
                                        + "margin-left: auto;"
                                        + "margin-right: auto;"
                                    + "}"
                                    + "html {"
                                        + "font-size: 20px;"
                                        + "font-family: \"-apple-system\";"
                                        + "color: white;"
                                    + "}"
                                    + "label {"
                                        + "font-size: 15px; "
                                    + "}"
                                + "</style>"
                            + "</head>"
        
        self.closingHtml = "</html>"
        
        if let description = self.currentStop?.stopDescription {
            self.middleHtml = description
        }
        
        setUpStopView()
        prepareViewForGestureRecognition()
    }
    
    func prepareViewForGestureRecognition() {
        self.stopDescription.isUserInteractionEnabled = true
        self.stopDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTextView(sender:))))
    }
    
    @objc func didTapTextView(sender: UITapGestureRecognizer) {
        if let index = self.stopDescription.characterIndexTapped(tap: sender){
            // if index is valid then do something.
            if index < self.stopDescription.textStorage.length {
                if let touched = self.stopDescription.attributedText.attribute(NSAttributedString.Key.attachment, at: index, effectiveRange: nil) as? NSTextAttachment, let fileName = touched.fileWrapper?.filename {
                    //open a full screen of the image
                    self.openFullScreen(fileName: fileName)
                }
            }
        }
    }
    
    func openFullScreen(fileName: String) {
        let storyBoard = UIStoryboard(name:"Main", bundle:nil)
        if let fullImageView = storyBoard.instantiateViewController(withIdentifier: "FullImageViewController") as? FullImageViewController {
            if let image = FileManager.default.getImageFromTemporaryDir(name: fileName) {
                fullImageView.image = image
            }
            else {
                fullImageView.image = UIImage(named: "default_preview_image")
            }
            
            navigationController?.pushViewController(fullImageView, animated: true)
        }
    }
    
    func setUpStopView() {
        stopName.text = currentStop?.stopName
        self.replaceImgSrc()
    }
    
    func replaceImgSrc() {
        //download all assets locally
        if self.databaseReference != nil && self.currentStop != nil {
            //try to parse the description as html
            do {
                let description = self.currentStop?.stopDescription ?? ""
                let doc:Document = try SwiftSoup.parse(description)
                
                //add progress indicator
                let progressIndicator = self.createCenteredProgressIndicator()
                self.view.addSubview(progressIndicator)
                progressIndicator.startAnimating()
                self.databaseReference?.locallyDownloadAssets(stopId: self.currentStop?.id ?? "", callback: {(assets) in
                    //we have recieved the assets
                    for asset in assets {
                        //replace the image tag src with the downloaded image path
                        if let url = asset.assetURL {
                            do {
                                if let imgElement = try doc.select("#" + asset.id).first {
                                    try imgElement.attr("src", url)
                                    //add the assets description
                                    if let description = asset.assetDescription {
                                        let labelHTML = "<label for='\(asset.id)'>\(description)</>"
                                        try imgElement.after(labelHTML)
                                    }
                                }
                            }
                            catch {
                                print(error)
                            }
                        }
                        else {
                            print("URL could not be retrieved")
                        }
                    }
                    do {
                        //try to convert back to string
                        self.middleHtml = try doc.body()?.outerHtml() ?? ""
                        print(self.middleHtml)
                        self.stopDescription.attributedText = self.convertDescriptionToHtml(description: self.middleHtml)
                    } catch { print(error) }
                    //stop animating progress indicator
                    progressIndicator.stopAnimating()
                })
            }
            catch {
                print(error)
            }
        }
    }
    
    func convertDescriptionToHtml(description: String) -> NSAttributedString? {
        let htmlStr = self.openingHtml + description + self.closingHtml
        let html = htmlStr.htmlToAttributedString
        return html
    }
    
}
