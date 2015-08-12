//
//  BannerWithThreeSubBannerCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FullImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var itemProductImageView: UIImageView!
    
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
}
