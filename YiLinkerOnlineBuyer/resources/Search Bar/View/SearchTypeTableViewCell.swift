//
//  SearchTypeTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 3/3/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var iconWidthConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func hideIcon() {
        self.iconWidthConstant.constant = 0
    }
    
}
