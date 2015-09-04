//
//  GeneralRatingTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class GeneralRatingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRating(rating: Int) {
        let views: NSArray = self.contentView.subviews
        
        for view in views {
            if view.isKindOfClass(UIImageView) {
                if view.tag <= rating {
                    let imageView: UIImageView = view as! UIImageView
                    imageView.image = UIImage(named: "rating2")
                }
            }
        }
    }
    
}
