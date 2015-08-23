//
//  RoundedButtonWithBorder.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class RoundedButtonWithBorder: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = titleColorForState(UIControlState.Normal)?.CGColor
    }
    
}
