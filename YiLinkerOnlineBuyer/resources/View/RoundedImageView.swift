//
//  RoundedImageView.swift
//  YiLinkerHomePage
//
//  Created by Alvin John Tandoc on 7/27/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

import UIKit

@IBDesignable class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = self.frame.size.width / 2
            layer.masksToBounds = newValue > 0
        }
    }
    
}
