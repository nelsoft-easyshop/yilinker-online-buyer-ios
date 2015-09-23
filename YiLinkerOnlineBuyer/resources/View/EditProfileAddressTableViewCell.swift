//
//  EditProfileAddressTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol EditProfileAddressTableViewCellDelegate{
    func changeAddressAction(sender: AnyObject)
}

class EditProfileAddressTableViewCell: UITableViewCell {
    
    var delegate: EditProfileAddressTableViewCellDelegate?

    @IBOutlet weak var addressSectionTitle: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var changeAdressIconButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addressLabel.sizeToFit()
        addressLabel.text = ""
        initializeLocalizedString()
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        var addressLocalizeString = StringHelper.localizedStringWithKey("ADDRESS_LOCALIZE_KEY")
        var defaultLocalizeString = StringHelper.localizedStringWithKey("DEFAULTADDRESS_LOCALIZE_KEY")
        var changeLocalizeString = StringHelper.localizedStringWithKey("CHANGEADDRESS_LOCALIZE_KEY")
        
        addressSectionTitle.text = addressLocalizeString
        addressTitleLabel.text = defaultLocalizeString
        changeAddressButton.setTitle(changeLocalizeString, forState: UIControlState.Normal)
    }
    
    @IBAction func changeAddressAction(sender: AnyObject) {
        delegate?.changeAddressAction(self)
    }

}
