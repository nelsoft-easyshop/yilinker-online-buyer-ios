//
//  SellerCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sellerTitleLabel: UILabel!
    @IBOutlet weak var sellerSubTitleLabel: UILabel!
    
    
    @IBOutlet weak var productOneImageView: UIImageView!
    @IBOutlet weak var productTwoImageView: UIImageView!
    @IBOutlet weak var productThreeImageView: UIImageView!
    
    @IBOutlet weak var sellerProfileImageView: RoundedImageView!
    var productModel: HomePageProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
