//
//  ProductitemWithVerticalDisplayCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/2/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductItemWithVerticalDisplayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var originalPriceLabel: DynamicRoundedLabel!
    @IBOutlet weak var discountedPriceLabel: DiscountLabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var discountPercentageLabel: DynamicRoundedLabel!
    
    var productModel: HomePageProductModel?
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
