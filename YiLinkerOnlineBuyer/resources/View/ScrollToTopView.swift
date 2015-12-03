//
//  ScrollToTopView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 12/2/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ScrollToTopView: UIView {

    @IBOutlet weak var backToTopButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backToTopButton.layer.cornerRadius = 10
        self.backgroundColor = UIColor.clearColor()
    }

}
