//
//  TwoColumnGridCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TwoColumnGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: DiscountLabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    
    var productModel: HomePageProductModel?
    
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        discountPercentageLabel.layer.cornerRadius = 3
        originalPriceLabel.layer.cornerRadius = 12
    }
}
