//
//  SimplifiedRegistrationUICollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol SimplifiedRegistrationUICollectionViewCellDelegate {
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, textFieldShouldReturn textField: UITextField)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapAreaCode areaCodeView: UIView)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapSendActivationCode sendActivationCodeButton: UIButton)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapRegister registerButton: UIButton)
}

class SimplifiedRegistrationUICollectionViewCell: UICollectionViewCell {
    
    var delegate: SimplifiedRegistrationUICollectionViewCellDelegate?
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var activationCodeTextField: UITextField!
    
    @IBOutlet weak var areaCodeView: UIView!
    @IBOutlet weak var areaCodeLabel: UILabel!

    @IBOutlet weak var sendActivationCodeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var downImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeViews()
        
        let viewTapGesture = UITapGestureRecognizer(target:self, action:"didTapAreaCode")
        self.areaCodeView.addGestureRecognizer(viewTapGesture)
    }
    
    func initializeViews() {
        self.mobileNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.referralCodeTextField.delegate = self
        self.activationCodeTextField.delegate = self
        
        self.registerButton.layer.cornerRadius = 3
        
        self.downImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
        //Set inset of textfield
        self.mobileNumberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.confirmPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.referralCodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.activationCodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        //Set border attributes
        self.mobileNumberTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.passwordTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.confirmPasswordTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.referralCodeTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.activationCodeTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.areaCodeView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        
        
        self.mobileNumberTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
        self.confirmPasswordTextField.layer.borderWidth = 1
        self.referralCodeTextField.layer.borderWidth = 1
        self.activationCodeTextField.layer.borderWidth = 1
        self.areaCodeView.layer.borderWidth = 1
        
        //TODO
        //Set placeholder
    }
    
    func didTapAreaCode() {
        self.delegate?.simplifiedRegistrationCell(self, didTapAreaCode: self.areaCodeView)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.sendActivationCodeButton {
            self.delegate?.simplifiedRegistrationCell(self, didTapSendActivationCode: self.sendActivationCodeButton)
        } else if sender == self.registerButton {
            self.delegate?.simplifiedRegistrationCell(self, didTapRegister: self.registerButton)
        }
    }
}

//MARK: -
//MARK: - TextField Delegate
extension SimplifiedRegistrationUICollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.simplifiedRegistrationCell(self, textFieldShouldReturn: textField)
        return true
    }
}
