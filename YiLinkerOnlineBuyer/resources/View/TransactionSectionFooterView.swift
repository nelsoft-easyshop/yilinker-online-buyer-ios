//
//  TransactionSectionFooterView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/11/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionSectionFooterView: UIView {

    @IBOutlet weak var leaveFeedbackButton: DynamicRoundedButton!
    
    @IBOutlet weak var sellerContactNumber: UILabel!
    
    @IBOutlet weak var sellerNameLabel: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        
    }
    
    @IBAction func leaveFeedback(sender: AnyObject) {
        println("leave feedback")
    }
    
    @IBAction func message(sender: AnyObject) {
        println("message")
    }
    
    

}
