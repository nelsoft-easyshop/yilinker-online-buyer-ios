//
//  ProductSellerViewCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductSellerViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setImage(image: String) {
        self.imageView.sd_setImageWithURL(NSURL(string: image)!, placeholderImage: UIImage(named: "dummy-placeholder"))
    }

}
