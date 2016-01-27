//
//  LoginTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/26/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LoginTableViewCellDelegate {
    func loginTableViewCellDelegate(loginTableViewCell: LoginTableViewCell, textFieldShouldReturn textField: UITextField)
    func loginTableViewCellDelegate(loginTableViewCell: LoginTableViewCell, didTapSignIn signInButton: UIButton)
    func loginTableViewCellDelegate(loginTableViewCell: LoginTableViewCell, didTapSuccessOnFacebookSignIn facebookButton: UIButton)
    func loginTableViewCellDelegate(loginTableViewCell: LoginTableViewCell, didTapForgotPassword forgotPasswordButton: UIButton)
}

class LoginTableViewCell: UITableViewCell, UITextFieldDelegate, FBSDKLoginButtonDelegate {

    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var siginInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var orLabel: UILabel!
    
    var delegate: LoginTableViewCellDelegate?
    
    var hud: MBProgressHUD?
    var mainController: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.facebookButton.layer.cornerRadius = 5
        self.siginInButton.layer.cornerRadius = 5
        
        self.passwordTextField.delegate = self
        self.emailTextField.delegate = self
        
        self.emailTextField.placeholder = LoginStrings.enterEmailAddress
        self.passwordTextField.placeholder = LoginStrings.enterPassword
        self.orLabel.text = LoginStrings.or
        self.forgotPasswordButton.setTitle(LoginStrings.forgotPasswordd, forState: UIControlState.Normal)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.returnUserData()
        } else {
            self.facebookButton.readPermissions = ["public_profile", "email"]
            self.facebookButton.delegate = self
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.loginTableViewCellDelegate(self, textFieldShouldReturn: textField)
        return true
    }
    
    //MARK: - 
    //MARK: - SignIn
    @IBAction func signIn(sender: UIButton) {
        self.delegate?.loginTableViewCellDelegate(self, didTapSignIn: sender)
    }
    
    //MARK: - 
    //MARK: - Login Button
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
                self.delegate?.loginTableViewCellDelegate(self, didTapSuccessOnFacebookSignIn: self.facebookButton)
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
                self.delegate?.loginTableViewCellDelegate(self, didTapSuccessOnFacebookSignIn: self.facebookButton)
            }
        })
    }
    
    //MARK: - 
    //MARK: - Forgot Password
    @IBAction func forgotPassword(sender: UIButton) {
        self.delegate?.loginTableViewCellDelegate(self, didTapForgotPassword: sender)
    }
}
