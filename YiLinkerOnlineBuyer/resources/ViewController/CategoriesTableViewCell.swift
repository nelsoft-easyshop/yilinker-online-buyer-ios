//
//  CategoriesTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pictureImageView.clipsToBounds = true
    }

    func setPicture(text: String) {
        self.pictureImageView.sd_setImageWithURL(NSURL(string: text), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
}
