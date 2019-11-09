//
//  TourTableViewCell.swift
//  GonzagaCampusWalkingTour
//
//  Created by Andrews, Alexa M on 11/9/19.
//  Copyright © 2019 Senior Design Group 8. All rights reserved.
//

import UIKit

class TourTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var tourName: UILabel!
    @IBOutlet weak var tourImage: UIImageView!
    @IBOutlet weak var tourDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
