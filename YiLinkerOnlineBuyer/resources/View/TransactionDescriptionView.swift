//
//  TransactionDescriptionView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDescriptionView: UIView {

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var seeMoreLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        
    }

    @IBAction func seeMoreAction(sender: AnyObject) {
        println("see more here")
    }
    
    
}
