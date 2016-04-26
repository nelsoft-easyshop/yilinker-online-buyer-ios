//
//  FourImageLayoutHeaderCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LayoutHeaderCollectionViewCellDelegate {
   func layoutHeaderCollectionViewCellDidSelectViewMore(layoutHeaderCollectionViewCell: LayoutHeaderCollectionViewCell)
}

class LayoutHeaderCollectionViewCell: UICollectionViewCell {
    
    var isWhiteBackgroundPresent: Bool = true
    var headerTitle: String = ""
    
    var target: String = ""
    var targetType: String = ""
    var sectionTitle: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLineView: UIView!
    
    @IBOutlet weak var viewMoreButton: UIButton!
    
    var delegate: LayoutHeaderCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLineView.layer.zPosition = 100
        
        self.viewMoreButton.layer.cornerRadius = 11
        self.viewMoreButton.layer.borderColor = Constants.Colors.appTheme.CGColor
        self.viewMoreButton.layer.borderWidth = 1.0
        
        self.viewMoreButton.setTitle(HomeCollectionViewStrings.viewMoreItems, forState: UIControlState.Normal)
    }
    
    //MARK: - Update Title Line
    func updateTitleLine() {
        let myString: String = self.titleLabel.text!
        let stringSize: CGSize = myString.sizeWithAttributes([NSFontAttributeName: self.titleLabel.font])
        self.widthConstraint.constant = stringSize.width
        self.titleLineView.layoutIfNeeded()
        self.titleLineView.updateConstraints()
    }
    
    //MARK: - View More
    @IBAction func viewMore(sender: AnyObject) {
        self.delegate?.layoutHeaderCollectionViewCellDidSelectViewMore(self)
    }
}
