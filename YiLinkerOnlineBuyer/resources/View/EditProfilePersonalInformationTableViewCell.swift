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
}

class EditProfilePersonalInformationTableViewCell: UITableViewCell, UITextFieldDelegate {

    var delegate: EditProfilePersonalInformationTableViewCellDelegate?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobilePhoneTextField: UITextField!
    
    @IBAction func editingAction(sender: AnyObject) {
        delegate?.passPersonalInformation(firstNameTextField.text, lastName: lastNameTextField.text, mobileNumber: mobilePhoneTextField.text)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
