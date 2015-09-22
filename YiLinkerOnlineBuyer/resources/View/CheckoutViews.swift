//
//  CheckoutViews.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CheckoutViews: UIView {

    @IBOutlet weak var totalPricelabel: UILabel!
    
    override func awakeFromNib() {
        for view in self.subviews {
            if view.tag == 10 {
                let label: UILabel = view as! UILabel
                label.text = CheckoutStrings.orderSummary
            } else if view.tag == 20 {
                let label: UILabel = view as! UILabel
                label.text = CheckoutStrings.delivery
            } else if view.tag == 30 {
                let label: UILabel = view as! UILabel
                label.text = CheckoutStrings.total
            } else if view.tag == 40 {
                let label: UILabel = view as! UILabel
                label.text = CheckoutStrings.free
            } else if view.tag == 50 {
                let label: UILabel = view as! UILabel
                label.text = CheckoutStrings.shipTo
            }
        }
    }
}
