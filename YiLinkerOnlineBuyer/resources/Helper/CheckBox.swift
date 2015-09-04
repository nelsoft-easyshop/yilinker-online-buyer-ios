//
//  CheckBox.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    let checkedImage = "filter-checked"
    let uncheckedImage = "filter-unchecked"
    private var checked : Bool = true
    
    func isChecked() -> Bool {
        return checked
    }

    // MARK: Initialization Code
    override init(frame: CGRect) {
        super.init(frame:frame)
        superFunkyInitializationCode()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        superFunkyInitializationCode()
    }
    
    private func superFunkyInitializationCode() {
        self.setImage(UIImage(named: checkedImage), forState: .Normal)
        self.addTarget(self, action:"didTouchUpInside", forControlEvents:.TouchUpInside)
    }
    
    // MARK: event handler for .TouchUpInside
    func didTouchUpInside() {
        toggleChecked()
    }

    private func toggleChecked() {
        self.checked = !self.checked
        if( self.checked ) {
            self.setImage(UIImage(named: checkedImage), forState: .Normal)
        }
        else {
            self.setImage(UIImage(named: uncheckedImage), forState: .Normal)
        }
    }
    
}
