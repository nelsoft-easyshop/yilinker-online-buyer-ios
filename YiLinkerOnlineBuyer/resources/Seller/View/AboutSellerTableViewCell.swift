//
//  AboutSellerTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class AboutSellerTableViewCell: UITableViewCell {

    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.separatorLine.backgroundColor = UIColor.lightGrayColor()
    }
    
}
