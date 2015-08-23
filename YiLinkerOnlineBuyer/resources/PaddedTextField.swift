//
//  PaddedTextField.swift
//  Messaging
//
//  Created by Dennis Nora on 8/19/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class PaddedTextField: UITextField {

    override func rightViewRectForBounds(bounds: CGRect) -> CGRect {
        var rightBounds = CGRectMake(bounds.size.width-20, 10, 11, 11)
        return rightBounds
    }

}
