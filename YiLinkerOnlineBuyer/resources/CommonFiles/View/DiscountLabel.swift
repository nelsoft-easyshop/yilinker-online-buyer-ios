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
    
    func drawDiscountLine() {
        let myString: NSString = self.text!
        let stringSize: CGSize = myString.sizeWithAttributes([NSFontAttributeName: self.font])
        
        let discoutLine: CALayer = CALayer()
        discoutLine.frame = CGRectMake(0, self.frame.size.height / 2, stringSize.width, 1)
        discoutLine.backgroundColor = UIColor.darkGrayColor().CGColor
        
        self.layer.addSublayer(discoutLine)
    }

}
