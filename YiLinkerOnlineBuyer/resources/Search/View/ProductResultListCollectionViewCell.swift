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
    
    @IBOutlet weak var overseasView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var wishListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.overseasView.hidden = true
    }
    
    func setDiscount(text: String) {
        if text == "0" {
            discountLabel.hidden = true
        } else {
            discountLabel.text = text + "% OFF"
        }
    }
    
    func setProductName(text: String) {
        productNameLabel.text = text
    }
    
    func setOriginalPrice(text: String) {
        let attrString = NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue])
        originalPriceLabel.attributedText = attrString
    }
    
    func setNewPrice(text: String) {
        newPriceLabel.text = text
    }
    
    func setProductImage(text: String) {
        productImageView.sd_setImageWithURL(NSURL(string: text), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setIsOverseas(isOverseas: Bool) {
        self.overseasView.hidden = !isOverseas
    }
}
