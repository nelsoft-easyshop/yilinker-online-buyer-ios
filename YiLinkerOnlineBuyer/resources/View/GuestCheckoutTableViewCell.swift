//
//  GuestCheckoutTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol GuestCheckoutTableViewCellDelegate {
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didStartEditingTextFieldWithTag textfieldTag: Int, textField: UITextField)
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didClickNext textfieldTag: Int, textField: UITextField)
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didClickDone textfieldTag: Int, textField: UITextField)
}

class GuestCheckoutTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var unitNumberTextField: UITextField!
    @IBOutlet weak var buildingNumberTextField: UITextField!
    @IBOutlet weak var streetNumberTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var subdivisionTextField: UITextField!
    @IBOutlet weak var provinceTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var barangayTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var additionalInfoTextField: UITextField!
    
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var mobileNumberLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var streetNumberLabel: UILabel!
    @IBOutlet weak var streetNameLabel: UILabel!
    @IBOutlet weak var zipCodelabel: UILabel!
    
    
    var delegate: GuestCheckoutTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var counter: Int = 0
        for (index, view) in enumerate(self.contentView.subviews) {
            if view.isKindOfClass(UITextField) {
                let textField: UITextField = view as! UITextField
                textField.delegate = self
                textField.tag = counter
                textField.autocorrectionType = UITextAutocorrectionType.No
                counter++
            }
        }
        
        self.firstNameLabel.required()
        self.lastNameLabel.required()
        self.mobileNumberLabel.required()
        self.emailAddressLabel.required()
        
        self.streetNameLabel.required()
        self.streetNumberLabel.required()
        self.zipCodelabel.required()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.guestCheckoutTableViewCell(self, didStartEditingTextFieldWithTag: textField.tag, textField: textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField != self.additionalInfoTextField {
            self.delegate?.guestCheckoutTableViewCell(self, didClickNext: textField.tag, textField: textField)
        } else {
            self.delegate?.guestCheckoutTableViewCell(self, didClickDone: textField.tag, textField: textField)
        }
        return true
    }
    
    func setBecomesFirstResponder(tag: Int) {
        for (index, view) in enumerate(self.contentView.subviews) {
            if view.isKindOfClass(UITextField) {
                let textField: UITextField = view as! UITextField
                if textField.tag == tag {
                    textField.becomeFirstResponder()
                }
            }
        }
    }
}
