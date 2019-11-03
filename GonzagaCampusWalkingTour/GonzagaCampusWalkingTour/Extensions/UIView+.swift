//
//  UIView+.swift
//  GonzagaCampusWalkingTour
//
//  Created by Max Heinzelman on 11/2/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviewAndPinEdges(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
