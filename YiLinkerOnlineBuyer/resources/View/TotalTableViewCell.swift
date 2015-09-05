//
//  TotalTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TotalTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: CGRectMake(0, 0, self.frame.size.width, self.contentView.frame.size.height), byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight, cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.contentView.bounds
        maskLayer.path = maskPath.CGPath
        self.contentView.layer.mask = maskLayer
    }
    
}
