//
//  LayoutNineCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/26/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LayoutNineCollectionViewCellDelegate {
    func layoutNineCollectionViewCellDidClickProductImage(productImage: ProductImageView)
}

class LayoutNineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageViewOne: ProductImageView!
    @IBOutlet weak var productImageViewTwo: ProductImageView!
    @IBOutlet weak var productImageViewThree: ProductImageView!
    @IBOutlet weak var productImageViewFour: ProductImageView!
    @IBOutlet weak var productImageViewFive: ProductImageView!
    
    @IBOutlet weak var productOneNameLabel: UILabel!
    @IBOutlet weak var productTwoNameLabel: UILabel!
    @IBOutlet weak var productThreeNameLabel: UILabel!
    @IBOutlet weak var productFourNameLabel: UILabel!
    @IBOutlet weak var productFiveNameLabel: UILabel!
    
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    
    var delegate: LayoutNineCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addTapRecognizer(productImageViewOne)
        self.addTapRecognizer(productImageViewTwo)
        self.addTapRecognizer(productImageViewThree)
        self.addTapRecognizer(productImageViewFour)
        self.addTapRecognizer(productImageViewFive)
        
        self.viewOne.layer.cornerRadius = 5
        self.viewTwo.layer.cornerRadius = 5
        self.viewThree.layer.cornerRadius = 5
        self.viewFour.layer.cornerRadius = 5
        self.viewFive.layer.cornerRadius = 5
    }
    
    //MARK: - Add Tap Recognizer
    func addTapRecognizer(productImageView: UIImageView) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapItem:")
        productImageView.userInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTapItem(tap: UITapGestureRecognizer) {
        let itemImageView: ProductImageView = tap.view as! ProductImageView
        self.delegate?.layoutNineCollectionViewCellDidClickProductImage(itemImageView)
    }
}
