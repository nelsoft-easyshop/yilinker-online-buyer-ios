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
    func addValidIDAction()
    func viewImageAction()
    func didTapCountryAction()
    func didTapLanguageAction()
}

class EditProfilePersonalInformationTableViewCell: UITableViewCell, UITextFieldDelegate {

    var delegate: EditProfilePersonalInformationTableViewCellDelegate?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    
    @IBOutlet weak var changeNumberButton: UIButton!
    @IBOutlet weak var addIDButton: UIButton!
    @IBOutlet weak var viewImageButton: UIButton!
    
    
    @IBOutlet weak var globalPreferencesLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryValueLabel: UILabel!
    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageValueLabel: UILabel!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var mobilePhoneLabel: UILabel!
    @IBOutlet weak var validIDLabel: UILabel!
    
    var addLocalizeString: String = ""
    var viewImageLocalizeString: String = ""
    var changeLocalizeString: String = ""
    
    @IBOutlet weak var viewImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var mobileNumberConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeLocalizedString()
        self.initializeViews()
        self.initializesTapGesture()
    }
    
    func initializeViews() {
        self.changeNumberButton.layer.cornerRadius = 8
        self.viewImageButton.layer.cornerRadius = 8
        self.addIDButton.layer.cornerRadius = 8
        
        self.countryView.layer.cornerRadius = 6
        self.languageView.layer.cornerRadius = 6
        self.countryView.layer.borderWidth = 0.5
        self.languageView.layer.borderWidth = 0.5
        self.countryView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.languageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.firstNameLabel.required()
        self.lastNameLabel.required()
        self.mobilePhoneLabel.required()
        self.countryLabel.required()
        self.languageLabel.required()
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        self.changeLocalizeString = StringHelper.localizedStringWithKey("CHANGE_LOCALIZE_KEY")
        let validIDPlaceholderLocalizeString = StringHelper.localizedStringWithKey("VALID_ID_PLACEHOLDER_LOCALIZED_KEY")
        self.addLocalizeString = StringHelper.localizedStringWithKey("ADD_LOCALIZED_KEY")
        self.viewImageLocalizeString = StringHelper.localizedStringWithKey("VIEW_IMAGE_LOCALIZED_KEY")
        
        self.changeNumberButton.setTitle(changeLocalizeString, forState: UIControlState.Normal)
        self.addIDButton.setTitle(addLocalizeString, forState: UIControlState.Normal)
        
        self.personalInfoLabel.text = StringHelper.localizedStringWithKey("PERSONALINFO_LOCALIZE_KEY")
        self.firstNameLabel.text = StringHelper.localizedStringWithKey("FIRSTNAME_LOCALIZE_KEY")
        self.lastNameLabel.text = StringHelper.localizedStringWithKey("LASTNAME_LOCALIZE_KEY")
        self.mobilePhoneLabel.text = StringHelper.localizedStringWithKey("MOBILE_LOCALIZE_KEY")
        self.validIDLabel.text = StringHelper.localizedStringWithKey("VALID_ID_LOCALIZED_KEY")
        self.globalPreferencesLabel.text = StringHelper.localizedStringWithKey("GLOBAL_PREFERENCES_KEY")
        self.countryLabel.text = StringHelper.localizedStringWithKey("PROFILE_COUNTRY_KEY")
        self.languageLabel.text = StringHelper.localizedStringWithKey("PROFILE_LANGUAGE_KEY")
    }
    
    func initializesTapGesture() {
        let countryGesture = UIGestureRecognizer(target: self, action: "didTapCountry")
        self.countryValueLabel.addGestureRecognizer(countryGesture)
        self.countryView.addGestureRecognizer(countryGesture)
        
        let languageGesture = UIGestureRecognizer(target: self, action: "didTapLanguage")
        self.languageValueLabel.addGestureRecognizer(languageGesture)
        self.languageView.addGestureRecognizer(languageGesture)
    }
    
    func showMobileNumberError(show: Bool) {
        if show {
            self.mobileNumberLabel.hidden = false
            self.mobileNumberConstraint.constant = 15
        } else {
            self.mobileNumberLabel.hidden = true
            self.mobileNumberConstraint.constant = 0
        }
    }
    
    @IBAction func editingAction(sender: AnyObject) {
        self.delegate?.passPersonalInformation(self.firstNameTextField.text, lastName: self.lastNameTextField.text, mobileNumber: self.mobilePhoneTextField.text)
    }
    
    @IBAction func changeMobileAction(sender: AnyObject) {
        self.delegate?.changeMobileNumberAction()
    }
    
    @IBAction func addIDAction(sender: AnyObject) {
        self.delegate?.addValidIDAction()
    }
    
    @IBAction func viewImageAction(sender: AnyObject) {
        self.delegate?.viewImageAction()
    }
    
    @IBAction func didTapCountry() {
        delegate?.didTapCountryAction()
    }
    
    @IBAction func didTapLanguage() {
        delegate?.didTapLanguageAction()
    }
}