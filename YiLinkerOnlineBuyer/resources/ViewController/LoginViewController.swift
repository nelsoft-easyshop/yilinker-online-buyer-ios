//
//  LoginViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate, UITextFieldDelegate {
   
    @IBOutlet weak var facebookButtonHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var gmailLoginButton: GIDSignInButton!
    @IBOutlet weak var gmailButtonHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var currentTextFieldTag: Int = 1
    var parentView: UIView?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.done()
    }
    
    override func viewDidLoad() {
        self.facebookButton.layer.cornerRadius = 5
        self.facebookButtonHeightConstraints.constant = 40
        self.view.needsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.returnUserData()
        } else {
            self.facebookButton.readPermissions = [Constants.Facebook.userPermissionPublicProfileKey, Constants.Facebook.userPermissionEmailKey, Constants.Facebook.userPermissionFriendsKey]
            self.facebookButton.delegate = self
        }
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
  
        self.setUpTextFields()
    }
    
    @IBAction func signIn(sender: AnyObject) {
        self.fireLogin()
    }
    
    func setUpTextFields() {
        self.passwordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.emailAddressTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.emailAddressTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains(Constants.Facebook.userPermissionEmailKey) {
                // Do work
                self.returnUserData()
            }
        }
    
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
            } else {
                if let val: AnyObject = result.valueForKey(Constants.Facebook.userNameKey) {
                    let userName : NSString = result.valueForKey(Constants.Facebook.userNameKey) as! NSString
                    println("fetched user: \(userName)")
                }
                
                if let val: AnyObject = result.valueForKey(Constants.Facebook.userIDKey) {
                    let uid : NSString = result.valueForKey(Constants.Facebook.userIDKey) as! NSString
                    println("fetched userID: \(uid)")
                }
               
                if let val: AnyObject = result.valueForKey(Constants.Facebook.userEmail) {
                    let email : NSString = result.valueForKey(Constants.Facebook.userEmail) as! NSString
                    println("fetched userID: \(email)")
                } else {
                    println("Email is not available!")
                }
            }
        })
    }
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let sessionManager: SessionManager = SessionManager.sharedInstance
        sessionManager.loginType = LoginType.FacebookLogin
    }
    
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
        withError error: NSError!) {
            // Perform any operations when the user disconnects from app here.
            // ...
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
            if (error == nil) {
                println(user.profile.name)
                // Perform any operations on signed in user here.
                let userId = user.userID                  // For client-side use only!
                let idToken = user.authentication.idToken // Safe to send to the server
                let name = user.profile.name
                let email = user.profile.email
                // ...
            } else {
                println("\(error.localizedDescription)")
            }
    }
    
    func done() {
        self.view.endEditing(true)
        self.adjustTextFieldYInsetWithInset(0)
        self.showCloseButton()
    }
    
    func previous() {
        let previousTag: Int = self.currentTextFieldTag - 1
        
        if let textField: UITextField = self.view.viewWithTag(previousTag) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            self.done()
        }
    }
    
    
    func next() {
        let nextTag: Int = self.currentTextFieldTag + 1
        
        if let textField: UITextField = self.view.viewWithTag(nextTag) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            self.done()
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.currentTextFieldTag = textField.tag
        if IphoneType.isIphone6() {
            let textFieldHeightWithInset: CGFloat = -25
            self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset)
        } else if IphoneType.isIphone4() {
            let textFieldHeightWithInset: CGFloat = -50
            self.hideCloseButton()
            if textField == self.passwordTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset)
            } else {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset)
            }
        }
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailAddressTextField {
            self.next()
        } else {
            self.done()
            self.fireLogin()
        }
        
        return true
    }
    
    func fireLogin() {
        var errorMessage: String = ""
        
        if !self.emailAddressTextField.isNotEmpty() {
            errorMessage = "Email is required."
        } else if !self.emailAddressTextField.isValidEmail() {
            errorMessage = "Email Address is not valid."
        } else if !self.passwordTextField.isNotEmpty() {
            errorMessage = "Password is required."
        }
        
        if errorMessage != "" {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorMessage)
        }
        
        self.view.endEditing(true)
        self.adjustTextFieldYInsetWithInset(0)
    }
    
    func adjustTextFieldYInsetWithInset(inset: CGFloat) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.verticalSpaceConstraint.constant = inset
                self.parentViewController!.view.layoutIfNeeded()
            }, completion: {(value: Bool) in
                
        })
    }
    
    func hideCloseButton() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.closeButton.alpha = 0
            }, completion: {(value: Bool) in
                
        })
    }
    
    func showCloseButton() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
            let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
            parentViewController.closeButton.alpha = 1
            }, completion: {(value: Bool) in
                
        })
    }
}
