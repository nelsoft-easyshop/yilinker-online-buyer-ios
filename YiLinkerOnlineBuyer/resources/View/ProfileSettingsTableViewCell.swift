//
//  ProfileSettingsTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProfileSettingsTableViewCellDelegate{
    func settingsSwitchAction(sender: AnyObject, value: Bool)
}

class ProfileSettingsTableViewCell: UITableViewCell {
    
    var delegate: ProfileSettingsTableViewCellDelegate?
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func switchAction(sender: AnyObject) {
        delegate?.settingsSwitchAction(self, value: (sender as! UISwitch).on)
    }
}
