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
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapLanguagePreference languagePreferenceView: UIView)
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapSendActivationCode sendActivationCodeButton: UIButton)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapRegister registerButton: UIButton)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTimerEnded sendActivationCodeButton: UIButton)
}

class SimplifiedRegistrationUICollectionViewCell: UICollectionViewCell {
    
    var delegate: SimplifiedRegistrationUICollectionViewCellDelegate?
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var activationCodeTextField: UITextField!
    
    @IBOutlet weak var languagePreferenceLabel: UILabel!
    @IBOutlet weak var languagePreferenceView: UIView!
    
    @IBOutlet weak var areaCodeView: UIView!
    @IBOutlet weak var areaCodeImageView: UIImageView!
    @IBOutlet weak var areaCodeLabel: UILabel!

    @IBOutlet weak var sendActivationCodeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var resendActivationLabel: UILabel!
    
    @IBOutlet weak var downImageView: UIImageView!
    @IBOutlet weak var downCodeImageView: UIImageView!
    
    var seconds: Int = 60
    var timer = NSTimer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeViews()
        
        let languageTapGesture = UITapGestureRecognizer(target:self, action:"didTapLanguagePrefence")
        self.languagePreferenceView.addGestureRecognizer(languageTapGesture)
        
        let areaCodeTapGesture = UITapGestureRecognizer(target:self, action:"didTapAreaCode")
        self.areaCodeView.addGestureRecognizer(areaCodeTapGesture)
    }
    
    func initializeViews() {
        self.mobileNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.referralCodeTextField.delegate = self
        self.activationCodeTextField.delegate = self
        
        self.registerButton.layer.cornerRadius = 3
        
        self.downImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        self.downCodeImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
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
        self.languagePreferenceView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        
        self.mobileNumberTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
        self.confirmPasswordTextField.layer.borderWidth = 1
        self.referralCodeTextField.layer.borderWidth = 1
        self.activationCodeTextField.layer.borderWidth = 1
        self.areaCodeView.layer.borderWidth = 1
        self.languagePreferenceView.layer.borderWidth = 1
        
        //Set placeholder
        self.mobileNumberTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.mobileNumber)
        self.passwordTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.password)
        self.confirmPasswordTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.confirmPassword)
        self.activationCodeTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.activationCode)
        self.sendActivationCodeButton.setTitle(RegisterStrings.getActivation, forState: .Normal)
        self.registerButton.setTitle(RegisterStrings.register.uppercaseString, forState: .Normal)
        
        self.resendActivationLabel.hidden = true
    }
    
    func didTapAreaCode() {
        self.delegate?.simplifiedRegistrationCell(self, didTapAreaCode: self.areaCodeView)
        println("Area Code")
    }
    
    func didTapLanguagePrefence() {
        self.delegate?.simplifiedRegistrationCell(self, didTapLanguagePreference: self.languagePreferenceView)
        println("Language Pref")
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.sendActivationCodeButton {
            self.delegate?.simplifiedRegistrationCell(self, didTapSendActivationCode: self.sendActivationCodeButton)
        } else if sender == self.registerButton {
            self.delegate?.simplifiedRegistrationCell(self, didTapRegister: self.registerButton)
        }
    }
    
    //Start the time
    func startTimer() {
        self.seconds = 60
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        self.sendActivationCodeButton.enabled = false
        self.sendActivationCodeButton.alpha = 0.5
        self.resendActivationLabel.hidden = false
        self.sendActivationCodeButton.setTitle("", forState: UIControlState.Normal)
    }
    
    //Decrement the time
    func subtractTime() {
        self.resendActivationLabel.text = "Resend Code in \(self.seconds) Seconds"
        self.seconds--
        if(seconds == 0)  {
            self.timer.invalidate()
            self.sendActivationCodeButton.setTitle(RegisterStrings.getActivation, forState: UIControlState.Normal)
            self.resendActivationLabel.text = "“Resend Code in 60 Seconds"
            self.resendActivationLabel.hidden = true
            self.sendActivationCodeButton.enabled = true
            self.sendActivationCodeButton.alpha = 1.0
            self.delegate?.simplifiedRegistrationCell(self, didTimerEnded: self.sendActivationCodeButton)
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
