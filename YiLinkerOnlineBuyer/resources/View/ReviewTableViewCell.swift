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

        //Set corner radius of imageview - circle shape
        displayPictureImageView.layer.cornerRadius = displayPictureImageView.frame.size.width / 2
        displayPictureImageView.clipsToBounds = true
    }

    //MARK: Set image to imageview
    func setDisplayPicture(text: String) {
        let imageUrl: NSURL = NSURL(string: text)!
        displayPictureImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    //MARK: Set name of buyer's feedbacks
    func setName(text: String) {
        nameLabel.text = text
    }
    
    //MARK: Set rating
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
    
    //MARK: Set image of imageview
    func rateImage(ctr: UIImageView) {
        ctr.image = UIImage(named: "rating2")
    }
    
    //MARK: Set message
    func setMessage(text: String) {
        self.messageLabel.text = text
    }

}
