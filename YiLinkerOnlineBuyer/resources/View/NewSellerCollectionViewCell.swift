//
//  NewSellerCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class NewSellerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sellerImageView: UIImageView!
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    var target: String = ""
    var targetType: String = ""
    
    var productModel: HomePageProductModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 5
    }

}
