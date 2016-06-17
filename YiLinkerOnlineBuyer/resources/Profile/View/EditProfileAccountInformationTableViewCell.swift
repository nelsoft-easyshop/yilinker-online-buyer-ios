//
//  EditProfileAccountInformationTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol EditProfileAccountInformationTableViewCellDelegate{
    func saveAction(sender: AnyObject)
    func editPasswordAction()
}

class EditProfileAccountInformationTableViewCell: UITableViewCell {

    var delegate: EditProfileAccountInformationTableViewCellDelegate?
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    @IBOutlet weak var accountInformationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
        initializeLocalizedString()
    }
    
    func initializeViews() {
        saveButton.layer.cornerRadius = 8
        changeEmailButton.layer.cornerRadius = 8
        changePasswordButton.layer.cornerRadius = 8
    }
    
    func initializeLocalizedString() {
        let accountInfoLocalizeString = StringHelper.localizedStringWithKey("ACCOUNTINFO_LOCALIZE_KEY")
        let emailLocalizeString = StringHelper.localizedStringWithKey("EMAILADD_LOCALIZE_KEY")
        let passwordLocalizeString = StringHelper.localizedStringWithKey("PASSWORD_LOCALIZE_KEY")
        let changeLocalizeString = StringHelper.localizedStringWithKey("CHANGE_LOCALIZE_KEY")
        let saveLocalizeString = StringHelper.localizedStringWithKey("SAVE_LOCALIZE_KEY")
        
        accountInformationLabel.text = accountInfoLocalizeString
        emailLabel.text = emailLocalizeString
        passwordLabel.text = passwordLocalizeString
        changePasswordButton.setTitle(changeLocalizeString, forState: UIControlState.Normal)
        saveButton.setTitle(saveLocalizeString, forState: UIControlState.Normal)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        delegate?.saveAction(self)
    }
    
    @IBAction func changeAction(sender: AnyObject) {
        self.delegate?.editPasswordAction()
    }

}
