//
//  ProductImagesViewCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductImagesViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var images: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setImage(image: String) {
        self.images.sd_setImageWithURL(NSURL(string: image)!, placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
}
