//
//  FlashSaleCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/25/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FlashSaleCollectionViewCellDelegate {
    func flashSaleCollectionViewCell(didTapProductImageView productImageView: ProductImageView)
}

class FlashSaleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var roundedView: UIView!
    
    @IBOutlet weak var hourFirstDigit: UILabel!
    @IBOutlet weak var hourSecondDigit: UILabel!
    
    @IBOutlet weak var minuteSecondDigit: UILabel!
    @IBOutlet weak var minuteFirstDigit: UILabel!
    
    @IBOutlet weak var secondSecondDigit: UILabel!
    @IBOutlet weak var secondFirstDigit: UILabel!
    
    @IBOutlet weak var productOneImageView: ProductImageView!
    @IBOutlet weak var productTwoImageView: ProductImageView!
    @IBOutlet weak var productThreeImageView: ProductImageView!
    
    @IBOutlet weak var productOneDiscountLabel: UILabel!
    @IBOutlet weak var productTwoDiscountLabel: UILabel!
    @IBOutlet weak var productThreeDiscountLabel: UILabel!
    
    var delegate: FlashSaleCollectionViewCellDelegate?
    
    var target: String = ""
    var targetType: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.roundedView.layer.cornerRadius = 5
        self.roundedView.clipsToBounds = true
        
        self.roundThisLabel(self.hourFirstDigit)
        self.roundThisLabel(self.hourSecondDigit)
        self.roundThisLabel(self.minuteSecondDigit)
        self.roundThisLabel(self.minuteFirstDigit)
        self.roundThisLabel(self.secondSecondDigit)
        self.roundThisLabel(self.secondFirstDigit)
        
        self.addTriangleToImageView(self.productOneImageView)
        self.addTriangleToImageView(self.productTwoImageView)
        self.addTriangleToImageView(self.productThreeImageView)
        
        self.addTapRecognizer(self.productOneImageView)
        self.addTapRecognizer(self.productTwoImageView)
        self.addTapRecognizer(self.productThreeImageView)
    }
    
    //MARK: - Round This Label
    func roundThisLabel(label: UILabel) {
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
    }
    
    //MARK: - Add Triangle To Image View
    func addTriangleToImageView(imageView: UIImageView) {
        let triangle: UIView = UIView(frame: CGRectMake(0, 0, 30, 30))
        imageView.layoutIfNeeded()
        triangle.center = CGPointMake((imageView.frame.size.width / 2) - 10, imageView.frame.size.height - 10)
        triangle.backgroundColor = UIColor.whiteColor()
        triangle.transform = CGAffineTransformMakeRotation((3.14159265358979323846264338327950288 / 4))
        triangle.userInteractionEnabled = false
        imageView.addSubview(triangle)
    }
    
    //MARK: - Add Tap Recognizer
    func addTapRecognizer(productImageView: UIImageView) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapItem:")
        productImageView.userInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTapItem(tap: UITapGestureRecognizer) {
        let itemImageView: ProductImageView = tap.view as! ProductImageView
        self.delegate?.flashSaleCollectionViewCell(didTapProductImageView: itemImageView)
    }
    
}
