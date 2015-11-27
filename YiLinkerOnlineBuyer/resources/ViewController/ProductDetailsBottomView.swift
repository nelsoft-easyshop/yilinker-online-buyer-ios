//
//  ProductDetailsBottomView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductDetailsBottomView: UIView {

    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        
        self.textLabel.text = ProductStrings.reachedBottom
    }
    
}
