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
    
    func addLabelAndPinEdgesToTopRight(_ label: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            label.heightAnchor.constraint(equalToConstant: 100),
            label.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
            label.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor)
        ])
    }
}
