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
        let myString: NSString = self.text!
        
        let stringSize: CGSize = myString.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12.0)])
        
        let discoutLine: CALayer = CALayer()
        discoutLine.frame = CGRectMake(0, self.frame.size.height / 2, stringSize.width, self.frame.size.height)
    }

}
