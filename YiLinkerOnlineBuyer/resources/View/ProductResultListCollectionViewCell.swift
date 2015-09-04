//
//  SearchResultListCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductResultListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var discountLabel: DynamicRoundedLabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var newPriceLabel: RoundedLabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var wishListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDiscount(text: String) {
        discountLabel.text = text + "% OFF"
    }
    
    func setProductName(text: String) {
        productNameLabel.text = text
    }
    
    func setOriginalPrice(text: String) {
        originalPriceLabel.text = text
    }
    
    func setNewPrice(text: String) {
        newPriceLabel.text = text
    }
    
    func setProductImage(text: String) {
        productImageView.sd_setImageWithURL(NSURL(string: text), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
}
