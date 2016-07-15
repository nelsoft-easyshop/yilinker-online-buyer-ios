
//
//  LayoutThirteenCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 7/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutThirteenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var labelContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.layer.cornerRadius = 2.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        
//        let whiteView: UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 250))
//        whiteView.backgroundColor = UIColor.redColor()
//        self.addSubview(whiteView)
    }

    
    func populateData(model: LayoutThirteenModel) {
        
    }
}
