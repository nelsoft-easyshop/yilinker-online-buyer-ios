//
//  IncompleteRequirementsTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol IncompleteRequirementsTableViewCellDelegate {
    func incompleteRequirementsTableViewCell(incompleteRequirementsTableViewCell: IncompleteRequirementsTableViewCell, didStartEditingAtTextField textField: UITextField)
    func incompleteRequirementsTableViewCell(incompleteRequirementsTableViewCell: IncompleteRequirementsTableViewCell, didChangeValueAtTextField textField: UITextField, textValue: String)
    func incompleteRequirementsTableViewCell(incompleteRequirementsTableViewCell: IncompleteRequirementsTableViewCell, didTapReturnAtTextField textField: UITextField)
}

class IncompleteRequirementsTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    private static let knibNameAndIdentiferKey = "IncompleteRequirementsTableViewCell"
    
    var delegate: IncompleteRequirementsTableViewCellDelegate?
    
    private let kTextFieldDicChangeAction = "textFieldDidChange:"
    
    //MARK: - 
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.localizedLabels()
        self.setupRequiredLabels()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.mobileNumberTextField.delegate = self
        self.emailAddressTextField.delegate = self
        
        self.firstNameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.lastNameTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.mobileNumberTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.emailAddressTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 
    //MARK: - Setup Required Labels
    func setupRequiredLabels() {
        self.firstNameLabel.required()
        self.lastNameLabel.required()
        self.mobileNumberLabel.required()
        self.emailAddressLabel.required()
    }
    
    //MARK: -
    //MARK: - Localized Labels
    func localizedLabels() {
        self.firstNameLabel.text = AddressStrings.firstName
        self.lastNameLabel.text = AddressStrings.lastName
        self.mobileNumberLabel.text = AddressStrings.mobileNumber
        self.emailAddressLabel.text = AddressStrings.emailAddress
    }
    
    //MARK: - 
    //MARK: - Nib Name And Identifier
    class func nibNameAndIdentifier() -> String {
        return IncompleteRequirementsTableViewCell.knibNameAndIdentiferKey
    }
    
    //MARK: - 
    //MARK: - Text Field Delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.incompleteRequirementsTableViewCell(self, didStartEditingAtTextField: textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.incompleteRequirementsTableViewCell(self, didTapReturnAtTextField: textField)
        return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        println(textField.text)
    }
    
    //MARK: - 
    //MARK: - Set First Name And Disabled Text Field With Value
    func setFirstNameAndDisabledTextFieldWithValue(name: String) {
        self.firstNameTextField.text = name
        self.firstNameTextField.enabled = false
    }
    
    //MARK: -
    //MARK: - Set Last Name And Disabled Text Field With Value
    func setLastNameAndDisabledTextFieldWithValue(lastName: String) {
        self.lastNameTextField.text = lastName
        self.lastNameTextField.enabled = false
    }
    
    //MARK: -
    //MARK: - Set Mobile Number And Disabled Text Field With Value
    func setMobileNumberAndDisabledTextWithFieldWithValue(mobileNumber: String) {
        self.mobileNumberTextField.text = mobileNumber
        self.mobileNumberTextField.enabled = false
    }
    
    //MARK: -
    //MARK: - Set Email Text Field And Disabled With Value
    func setEmailAndDisabledTextFieldWithValue(email: String) {
        self.emailAddressTextField.text = email
        self.emailAddressTextField.enabled = false
    }
    
}
