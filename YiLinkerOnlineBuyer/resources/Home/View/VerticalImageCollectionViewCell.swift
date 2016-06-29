//
//  FourImageCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class VerticalImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var discountedPriceLabel: DynamicRoundedLabel!
    @IBOutlet weak var originalPriceLabel: DiscountLabel!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var discountPercentageLabel: DynamicRoundedLabel!
    
    var productModel: HomePageProductModel?
    
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
