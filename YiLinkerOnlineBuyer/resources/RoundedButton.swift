//
//  RoundedButton.swift
//  Messaging
//
//  Created by Dennis Nora on 8/21/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
    }

}
