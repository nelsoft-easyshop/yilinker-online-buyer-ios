//
//  FourImageLayoutHeaderCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutHeaderCollectionViewCell: UICollectionViewCell {
    
    var isWhiteBackgroundPresent: Bool = true
    var headerTitle: String = ""
    
    var target: String = ""
    var targetType: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLineView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLineView.layer.zPosition = 100
    }
    
    func updateTitleLine() {
        let myString: String = self.titleLabel.text!
        let stringSize: CGSize = myString.sizeWithAttributes([NSFontAttributeName: self.titleLabel.font])
        self.widthConstraint.constant = stringSize.width
        self.titleLineView.layoutIfNeeded()
        self.titleLineView.updateConstraints()
    }

}
