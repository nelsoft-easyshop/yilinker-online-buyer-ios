//
//  ReviewTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/4/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ReviewTableViewCellDelegate{
    
}

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var displayPictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rateImageView1: UIImageView!
    @IBOutlet weak var rateImageView2: UIImageView!
    @IBOutlet weak var rateImageView3: UIImageView!
    @IBOutlet weak var rateImageView4: UIImageView!
    @IBOutlet weak var rateImageView5: UIImageView!
    
    var delegate: ReviewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        displayPictureImageView.layer.cornerRadius = displayPictureImageView.frame.size.width / 2
        displayPictureImageView.clipsToBounds = true
    }

    func setDisplayPicture(text: String) {
        let imageUrl: NSURL = NSURL(string: "http://p1.i.ntere.st/a438be228da13ca14d1a84feffdbf816_480.jpg")!
        displayPictureImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setName(text: String) {
        nameLabel.text = text
    }
    
    func setRating(rate: String) {
        
        var r: Int = NSString(string: rate).integerValue
        
        if r > 4 {
            rateImage(rateImageView5)
        }
        
        if r > 3 {
            rateImage(rateImageView4)
        }
        
        if r > 2 {
            rateImage(rateImageView3)
        }
        
        if r > 1  {
            rateImage(rateImageView2)
        }
        
        if r > 0 {
            rateImage(rateImageView1)
        }
    }
    
    func rateImage(ctr: UIImageView) {
        ctr.image = UIImage(named: "rating2")
    }
    
    func setMessage(text: String) {
        self.messageLabel.text = text
    }

}
