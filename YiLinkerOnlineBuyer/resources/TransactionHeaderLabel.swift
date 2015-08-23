//
//  TransactionHeaderLabel.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class TransactionHeaderLabel: UILabel {
    
    override func drawTextInRect(rect: CGRect) {
        var customInset = UIEdgeInsets(top: 5, left: 17, bottom: 0, right: 0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, customInset))
    }

}
