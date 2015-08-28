//
//  RoundedButton.swift
//  YiLinkerHomePage
//
//  Created by Alvin John Tandoc on 7/27/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = self.frame.size.width / 2
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func awakeFromNib() {
        self.layer.zPosition = 10
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clearColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

}
