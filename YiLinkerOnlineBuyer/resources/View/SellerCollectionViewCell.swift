//
//  SellerCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol SellerCollectionViewCellDelegate {
    func didSelectProductWithTarget(target: String, targetType: String)
}

class SellerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sellerTitleLabel: UILabel!
    @IBOutlet weak var sellerSubTitleLabel: UILabel!
    
    @IBOutlet weak var productOneImageView: ProductImageView!
    @IBOutlet weak var productTwoImageView: ProductImageView!
    @IBOutlet weak var productThreeImageView: ProductImageView!
    @IBOutlet weak var sellerProfileImageView: RoundedImageView!
    
    var delegate: SellerCollectionViewCellDelegate?
    
    var target: String = ""
    var targetType: String = ""
    var userId = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
        
        for view in self.contentView.subviews {
            if view.tag != 0 {
                let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapImage:")
                let productImageView: ProductImageView = view as! ProductImageView
                productImageView.userInteractionEnabled = true
                productImageView.addGestureRecognizer(tapRecognizer)
            }
        }

    }
    
    func didTapImage(sender: UITapGestureRecognizer) {
        let productImageView: ProductImageView = sender.view as! ProductImageView
        self.delegate?.didSelectProductWithTarget(productImageView.target, targetType: productImageView.targetType)
    }
}
