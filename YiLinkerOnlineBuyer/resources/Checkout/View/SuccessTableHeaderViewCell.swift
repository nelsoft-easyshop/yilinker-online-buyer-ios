//
//  SuccessHeaderView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SuccessTableHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var successMessageLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
 
     override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath: UIBezierPath = UIBezierPath(roundedRect: CGRectMake(0, 0, self.frame.size.width, self.roundedView.frame.size.height), byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.TopRight, cornerRadii: CGSize(width: 5.0, height: 5.0))
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = self.roundedView.bounds
        maskLayer.path = maskPath.CGPath
        self.roundedView.layer.mask = maskLayer
        
        self.congratsLabel.text = OverViewStrings.congrats
        self.successMessageLabel.text = OverViewStrings.successPurchase
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
