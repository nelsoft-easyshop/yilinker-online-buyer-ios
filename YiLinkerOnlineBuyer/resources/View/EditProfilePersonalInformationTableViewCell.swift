//
//  EditProfilePersonalInformationTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol EditProfilePersonalInformationTableViewCellDelegate {
    func passPersonalInformation(firstName: String, lastName: String, mobileNumber: String)
    func changeMobileNumberAction()
}

class EditProfilePersonalInformationTableViewCell: UITableViewCell, UITextFieldDelegate {

    var delegate: EditProfilePersonalInformationTableViewCellDelegate?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    
    @IBOutlet weak var changeNumberButton: UIButton!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    
    @IBAction func editingAction(sender: AnyObject) {
        delegate?.passPersonalInformation(firstNameTextField.text, lastName: lastNameTextField.text, mobileNumber: mobilePhoneTextField.text)
    }

    @IBAction func changeMobileAction(sender: AnyObject) {
        delegate?.changeMobileNumberAction()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeLocalizedString()
        initializeViews()
    }
    
    func initializeViews() {
        changeNumberButton.layer.cornerRadius = 8
        firstNameLabel.required()
        lastNameLabel.required()
        mobilePhoneLabel.required()
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        let personalLocalizeString = StringHelper.localizedStringWithKey("PERSONALINFO_LOCALIZE_KEY")
        let firstNameLocalizeString = StringHelper.localizedStringWithKey("FIRSTNAME_LOCALIZE_KEY")
        let lastNameLocalizeString = StringHelper.localizedStringWithKey("LASTNAME_LOCALIZE_KEY")
        let mobileNameLocalizeString = StringHelper.localizedStringWithKey("MOBILE_LOCALIZE_KEY")
        let changeLocalizeString = StringHelper.localizedStringWithKey("CHANGE_LOCALIZE_KEY")
        
        changeNumberButton.setTitle(changeLocalizeString, forState: UIControlState.Normal)
        
        personalInfoLabel.text = personalLocalizeString
        firstNameLabel.text = firstNameLocalizeString
        lastNameLabel.text = lastNameLocalizeString
        mobilePhoneLabel.text = mobileNameLocalizeString
    }
    
}
