//
//  FollowedSellerTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FollowedSellerTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pictureImageView.layer.cornerRadius = pictureImageView.frame.size.width / 2
        pictureImageView.clipsToBounds = true
    }

    // MARK: - Methods
    
    func setPicture(text: String) {
        self.pictureImageView.sd_setImageWithURL(NSURL(string: text), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setRating(rating: Int) {
        
        for view in self.ratingsView.subviews {
            view.removeFromSuperview()
        }
        
        let size: CGFloat = 20.0//self.ratingsView.frame.size.height
        
        for i in 0..<5 {
            
            let counter: Int = Int(i)
            let image = UIImageView(frame: CGRectMake(CGFloat(CGFloat(i) * (size + 2)), 0, size, size))
            
            if i < rating {
                image.image = UIImage(named: "rating2")
            } else {
                image.image = UIImage(named: "rating")
            }
            
            self.ratingsView.addSubview(image)
        }
    }
    
}
