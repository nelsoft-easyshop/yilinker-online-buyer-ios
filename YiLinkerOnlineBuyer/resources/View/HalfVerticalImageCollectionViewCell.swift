//
//  FourImageHalfVerticalCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HalfVerticalImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var originalPriceLabel: DynamicRoundedLabel!
    
    @IBOutlet weak var discountedPriceLabel: DiscountLabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var discountPercentageLabel: DynamicRoundedLabel!
    @IBOutlet weak var productItemImageView: UIImageView!
    
    var target: String = ""
    var targetType: String = ""
    
    var productModel: HomePageProductModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
