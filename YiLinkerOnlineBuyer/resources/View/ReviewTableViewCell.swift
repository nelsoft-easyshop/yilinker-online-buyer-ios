//
//  ReviewTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/4/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var displayPictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rateImageView1: UIImageView!
    @IBOutlet weak var rateImageView2: UIImageView!
    @IBOutlet weak var rateImageView3: UIImageView!
    @IBOutlet weak var rateImageView4: UIImageView!
    @IBOutlet weak var rateImageView5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        displayPictureImageView.layer.cornerRadius = displayPictureImageView.frame.size.width / 2
        displayPictureImageView.clipsToBounds = true
    }

    func setDisplayPicture(text: String) {
        
    }
    
    func setName(text: String) {
        nameLabel.text = text
    }
    
    func setRating(text: Float) {

    }
    
    func setMessage(text: String) {
        self.messageLabel.text = text
    }
    
}
