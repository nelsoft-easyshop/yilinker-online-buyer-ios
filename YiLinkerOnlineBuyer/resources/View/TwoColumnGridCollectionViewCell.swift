//
//  TwoColumnGridCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TwoColumnGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: DiscountLabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var discountPercentageLabel: UILabel!
    
    var productModel: HomePageProductModel?
    
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        discountPercentageLabel.layer.cornerRadius = 5
        discountPercentageLabel.clipsToBounds = true
        
        discountedPriceLabel.layer.cornerRadius = 12
        discountedPriceLabel.clipsToBounds = true
    }
}
