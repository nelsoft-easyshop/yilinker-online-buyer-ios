//
//  RoundedLabel.swift
//  Messaging
//
//  Created by Dennis Nora on 8/21/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel {

    override func drawTextInRect(rect: CGRect) {
        var customInset = UIEdgeInsets(top: 2, left: 7, bottom: 2, right: 7)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, customInset))
    }

}
