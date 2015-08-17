//
//  ProfilePersonalTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfilePersonalTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func endEdittingAction(sender: AnyObject) {
        if sender as! NSObject == firstNameTextField {
            println("firstNameTextField")
        } else if sender as! NSObject == lastNameTextField {
            println("lastNameTextField")
        } else if sender as! NSObject == mobileNumberTextField {
            println("mobileNumberTextField")
        }
    }
    
    
}
