//
//  ProfileAccountSettingsTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileAccountSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var deactivateSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchAction(sender: AnyObject) {
        if sender as! NSObject == notificationSwitch {
            
        } else if sender as! NSObject == deactivateSwitch {
            
        }
    }
}
