//
//  SemiRoundedButton.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/29/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

@IBDesignable class SemiRoundedButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

}
