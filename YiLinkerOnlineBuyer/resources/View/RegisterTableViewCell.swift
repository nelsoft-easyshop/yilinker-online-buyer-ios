//
//  RegisterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/26/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol RegisterTableViewCellDelegate {
    func registerTableViewCell(registerTableViewCell: RegisterTableViewCell, textFieldShouldReturn textField: UITextField)
    func registerTableViewCell(registerTableViewCell: RegisterTableViewCell, didTapRegister button: UIButton)
}

class RegisterTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var delegate: RegisterTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initTextViews()
        self.registerButton.setTitle(RegisterStrings.registerMeNow, forState: UIControlState.Normal)
        self.registerButton.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 
    //MARK: - Register
    @IBAction func register(sender: UIButton) {
        self.delegate?.registerTableViewCell(self, didTapRegister: sender)
    }
    
    //MARK: -
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.registerTableViewCell(self, textFieldShouldReturn: textField)
        return true
    }
    
    //MARK: - 
    //MARK: - Init Text Views
    func initTextViews() {
        self.firstNameTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.firstName)
        self.lastNameTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.lastName)
        self.emailAddressTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.emailAddress)
        self.passwordTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.password)
        self.reTypePasswordTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.reTypePassword)
        self.mobileNumberTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.mobileNumber)
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailAddressTextField.delegate = self
        self.passwordTextField.delegate = self
        self.reTypePasswordTextField.delegate = self
        self.mobileNumberTextField.delegate = self
    }
}
