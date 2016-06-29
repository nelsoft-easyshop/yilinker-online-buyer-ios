//
//  ScrollableProductCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductWithCenterNameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var productNameLabel: RoundedLabel!
    
    var productModel: HomePageProductModel?
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
