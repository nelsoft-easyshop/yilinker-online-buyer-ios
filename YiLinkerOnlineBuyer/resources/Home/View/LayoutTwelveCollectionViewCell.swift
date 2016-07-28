//
//  LayoutTwelveCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 7/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LayoutTwelveCollectionViewCellDelegate {
    func layoutTwelveCollectionViewCellDidClickProductImage(productImage: ProductImageView)
}

class LayoutTwelveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftImageView: ProductImageView!
    @IBOutlet weak var rightUpperImageView: ProductImageView!
    @IBOutlet weak var rightLowerImageView: ProductImageView!

    var delegate: LayoutTwelveCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupViews()
    }
    
    
    func setupViews() {
        setupBorderOf(leftImageView)
        setupBorderOf(rightUpperImageView)
        setupBorderOf(rightLowerImageView)
        
        addTapRecognizer(leftImageView)
        addTapRecognizer(rightUpperImageView)
        addTapRecognizer(rightLowerImageView)
    }
    
    func setupBorderOf(imageView: UIImageView) {
        imageView.layer.cornerRadius = 2.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
    }
    
    //MARK: - Add Tap Recognizer
    func addTapRecognizer(productImageView: UIImageView) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapItem:")
        productImageView.userInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTapItem(tap: UITapGestureRecognizer) {
        let itemImageView: ProductImageView = tap.view as! ProductImageView
        self.delegate?.layoutTwelveCollectionViewCellDidClickProductImage(itemImageView)
    }

}
