//
//  UITextView+.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 4/2/20.
//  Copyright © 2020 Senior Design Group 8. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func characterIndexTapped(tap: UITapGestureRecognizer) -> Int? {
        let layoutManager = self.layoutManager
        // location of tap in myTextView coordinates and taking the inset into account
        var location = tap.location(in: self)
        location.x -= self.textContainerInset.left;
        location.y -= self.textContainerInset.top;

        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return characterIndex
    }
}
