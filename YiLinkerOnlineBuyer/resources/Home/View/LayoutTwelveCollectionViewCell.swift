//
//  LayoutTwelveCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 7/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutTwelveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightUpperImageView: UIImageView!
    @IBOutlet weak var rightLowerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    
    func setupViews() {
        setupBorderOf(leftImageView)
        setupBorderOf(rightUpperImageView)
        setupBorderOf(rightLowerImageView)
    }
    
    func setupBorderOf(imageView: UIImageView) {
        imageView.layer.cornerRadius = 2.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
    }

}
