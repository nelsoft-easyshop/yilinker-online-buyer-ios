//
//  LabelWithDiscountLine.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class DiscountLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func drawDiscountLine(floatLeft: Bool) {
        self.layer.sublayers = nil
        let myString: NSString = self.text!
        let stringSize: CGSize = myString.sizeWithAttributes([NSFontAttributeName: self.font])
        let discoutLine: CALayer = CALayer()
        discoutLine.frame = CGRectMake(0, self.frame.size.height / 2, stringSize.width, 1)
        if floatLeft {
            discoutLine.frame.origin.x = self.frame.size.width - discoutLine.frame.size.width
        }
        discoutLine.backgroundColor = UIColor.grayColor().CGColor
        self.layer.addSublayer(discoutLine)
    }

}
