//
//  SimplifiedLoginTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol SimplifiedLoginUICollectionViewCellDelegate {
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, textFieldShouldReturn textField: UITextField)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapFBLogin facebookButton: FBSDKLoginButton)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapForgotPassword forgotPasswordButton: UIButton)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapSignin signInButton: UIButton)
}

class SimplifiedLoginUICollectionViewCell: UICollectionViewCell {
    
    var delegate: SimplifiedLoginUICollectionViewCellDelegate?
    
    @IBOutlet weak var byMobileButton: UIButton!
    @IBOutlet weak var byEmailButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    @IBOutlet weak var emailMobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var areaCodeView: UIView!
    @IBOutlet weak var areaCodeLabel: UILabel!
    @IBOutlet weak var areaCodeConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var downImageView: UIImageView!
    
    var isMobileLogin: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initializeViews()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.returnUserData()
        } else {
            self.facebookButton.readPermissions = ["public_profile", "email"]
            self.facebookButton.delegate = self
        }
    }
    
    func initializeViews() {
        self.emailMobileTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.downImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
        self.signInButton.layer.cornerRadius = 3
        self.facebookButton.layer.cornerRadius = 3
        
        //Set inset of textfield
        self.emailMobileTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        //Set border attributes
        self.emailMobileTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.passwordTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.areaCodeView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        
        self.emailMobileTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
        self.areaCodeView.layer.borderWidth = 1
        
        //Set string
        self.byMobileButton.setTitle(LoginStrings.byMobile, forState: .Normal)
        self.byEmailButton.setTitle(LoginStrings.byEmail, forState: .Normal)
        self.signInButton.setTitle(LoginStrings.signIn.uppercaseString, forState: .Normal)
        self.emailMobileTextField.placeholder = LoginStrings.mobileNUmber
        self.passwordTextField.placeholder = LoginStrings.password
        
        self.buttonAction(self.byMobileButton)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        self.endEditing(true)
        if sender == self.byMobileButton {
            self.isMobileLogin = true
            self.byMobileButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
            self.byEmailButton.setTitleColor(Constants.Colors.grayText, forState: UIControlState.Normal)
            self.emailMobileTextField.keyboardType = UIKeyboardType.PhonePad
            self.emailMobileTextField.text = ""
            self.emailMobileTextField.placeholder = LoginStrings.mobileNUmber
            self.areaCodeConstraint.constant = 69
            UIView.animateWithDuration(0.25) {
                self.layoutIfNeeded()
            }
        } else if sender == self.byEmailButton {
            self.isMobileLogin = false
            self.byEmailButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
            self.byMobileButton.setTitleColor(Constants.Colors.grayText, forState: UIControlState.Normal)
            self.emailMobileTextField.keyboardType = UIKeyboardType.EmailAddress
            self.emailMobileTextField.text = ""
            self.emailMobileTextField.placeholder = LoginStrings.emailAddress
            self.areaCodeConstraint.constant = 0
            UIView.animateWithDuration(0.25) {
                self.layoutIfNeeded()
            }
        } else if sender == self.forgotPasswordButton {
           self.delegate?.simplifiedLoginCell(self, didTapForgotPassword: self.forgotPasswordButton)
        } else if sender == self.signInButton {
            self.delegate?.simplifiedLoginCell(self, didTapSignin: self.signInButton)
        }
    }
}

//MARK: -
//MARK: - TextField Delegate
extension SimplifiedLoginUICollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.simplifiedLoginCell(self, textFieldShouldReturn: textField)
        return true
    }
}

//MARK: -
//MARK: - Facebobk Login Button
extension SimplifiedLoginUICollectionViewCell: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil) {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                self.delegate?.simplifiedLoginCell(self, didTapFBLogin: self.facebookButton)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                FBSDKLoginManager().logOut()
            }
            else {
                self.delegate?.simplifiedLoginCell(self, didTapFBLogin: self.facebookButton)
            }
        })
    }
}