
//
//  LayoutThirteenCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 7/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutThirteenCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

}
