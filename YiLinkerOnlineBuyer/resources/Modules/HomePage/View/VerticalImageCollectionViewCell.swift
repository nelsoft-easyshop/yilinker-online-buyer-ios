//
//  FourImageCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class VerticalImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var originalPriceLabel: DynamicRoundedLabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var discountPercentageLabel: DynamicRoundedLabel!
    
    var productModel: HomePageProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
