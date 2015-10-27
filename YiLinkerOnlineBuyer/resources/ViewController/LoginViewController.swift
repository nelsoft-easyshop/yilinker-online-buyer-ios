//
//  LoginViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

struct LoginStrings {
    static let enterEmailAddress: String = StringHelper.localizedStringWithKey("ENTER_EMAIL_ADDRESS_LOCALIZE_KEY")
    static let enterPassword: String = StringHelper.localizedStringWithKey("ENTER_PASSWORD_ADDRESS_LOCALIZE_KEY")
    
    static let mismatch: String = StringHelper.localizedStringWithKey("MISMATCH_LOCALIZE_KEY")
    static let loginFailed: String = StringHelper.localizedStringWithKey("LOGIN_FAILED_LOCALIZE_KEY")
    
    static let emailIsRequired: String = StringHelper.localizedStringWithKey("INVALID_EMAIL_REQUIRED_LOCALIZE_KEY")
    static let invalidEmail: String = StringHelper.localizedStringWithKey("INVALID_EMAIL_REQUIRED_LOCALIZE_KEY")
    static let passwordIsRequired: String = StringHelper.localizedStringWithKey("PASSWORD_IS_REQUIRED_LOCALIZE_KEY")
    
    static let successMessage: String = StringHelper.localizedStringWithKey("SUCCESS_LOGIN_LOCALIZE_KEY")
    static let or: String = StringHelper.localizedStringWithKey("OR_LOCALIZE_KEY")
    static let forgotPasswordd: String = StringHelper.localizedStringWithKey("FORGOT_PASSWORD_LOCALIZE_KEY")
}


private struct LoginConstants {
    static let homeServerClientID = "231249450400-dso2pqhieqta2h78m9shhu8qs7gi3jji.apps.googleusercontent.com"
    static let forgotPasswordUrlString = "http://online.api.easydeal.ph/forgot-password-request"
    
    static let emailKey = "email"
    static let passwordKey = "password"
    static let clientIdKey = "client_id"
    static let clientSecretKey = "client_secret"
    static let grantTypeKey = "grant_type"
    
    static let registrationIdKey = "registrationId"
    static let accessTokenKey = "access_token"
    
    static let tokenKey = "token"
}

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, UITextFieldDelegate, GPPSignInDelegate {
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    @IBOutlet weak var gmailLoginButton: GPPSignInButton!
    
    @IBOutlet weak var gmailButtonHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var currentTextFieldTag: Int = 1
    var parentView: UIView?
    var hud: MBProgressHUD?
    
    //MARK: - ViewDidAppear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailAddressTextField.placeholder = LoginStrings.enterEmailAddress
        self.passwordTextField.placeholder = LoginStrings.enterPassword
        self.orLabel.text = LoginStrings.or
        self.forgotPasswordButton.setTitle(LoginStrings.forgotPasswordd, forState: UIControlState.Normal)
    }
    
    //MARK: - ViewDidDisappear
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            self.done()
        }
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        self.facebookButton.layer.cornerRadius = 5
        self.view.needsUpdateConstraints()
        self.view.layoutIfNeeded()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            self.returnUserData()
        } else {
            self.facebookButton.readPermissions = [Constants.Facebook.userPermissionPublicProfileKey, Constants.Facebook.userPermissionEmailKey, Constants.Facebook.userPermissionFriendsKey]
            self.facebookButton.delegate = self
        }
        
        self.setupSignInButton()
        self.setUpTextFields()
        self.setUpGmailLogin()
    }
    
    //MARK: Setup Signin Button
    func setupSignInButton() {
        self.signInButton.layer.cornerRadius = 5
        self.signInButton.setTitle(FABStrings.signIn, forState: UIControlState.Normal)
    }
    
    //MARK: - Gmail Login
    func setUpGmailLogin() {
        let signIn: GPPSignIn = GPPSignIn.sharedInstance()
        signIn.shouldFetchGooglePlusUser = true
        signIn.shouldFetchGoogleUserEmail = true
        signIn.homeServerClientID = LoginConstants.homeServerClientID
        signIn.clientID = Constants.Credentials.gmailCredential
        signIn.scopes = [kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe, kGTLAuthScopePlusUserinfoEmail]
        signIn.delegate = self
        self.gmailLoginButton.layer.cornerRadius = 5
    }
    
    //MARK: - Forgot Password Action
    @IBAction func forgotPassword(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: LoginConstants.forgotPasswordUrlString)!)
    }
    
    //MARK: - HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //MARK: - Google Plus Sign in
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if error == nil {
            println(GPPSignIn.sharedInstance().idToken)
            self.fireGooglePlusLoginWithToken(GPPSignIn.sharedInstance().idToken)
        }
    }
    
    //MARK: - Setup TextFields
    func setUpTextFields() {
        self.passwordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.emailAddressTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.emailAddressTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    //MARK: - FBLogin Callback
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
    
    @IBAction func facebookLogin(sender: AnyObject) {
        let sessionManager: SessionManager = SessionManager.sharedInstance
        sessionManager.loginType = LoginType.FacebookLogin
    }
    
    //MARK: - FB Get User Data
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
            } else {
                var uid: String = ""
                
                if let val: AnyObject = result.valueForKey(Constants.Facebook.userNameKey) {
                    let userName : NSString = result.valueForKey(Constants.Facebook.userNameKey) as! NSString
                }
                
                if let val: AnyObject = result.valueForKey(Constants.Facebook.userIDKey) {
                    uid = result.valueForKey(Constants.Facebook.userIDKey) as! String
                }
                
                if let val: AnyObject = result.valueForKey(Constants.Facebook.userEmail) {
                    let email : String = result.valueForKey(Constants.Facebook.userEmail) as! String
                } else {
                    
                }
                
                self.fireFacebookLoginWithToken(self.getFaceBookAccessToken())
                
            }
        })
    }
    
    //MARK: - Get Facebook Access Token
    func getFaceBookAccessToken() -> String {
        var accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        return accessToken
    }
    
    //MARK: - Sign In
    @IBAction func signIn(sender: AnyObject) {
        self.login()
    }
    
    //MARK: - Done
    func done() {
        let manager = APIManager.sharedInstance
        manager.operationQueue.cancelAllOperations()
        self.view.endEditing(true)
        self.adjustTextFieldYInsetWithInset(0)
        self.showCloseButton()
    }
    
    //MARK: - Previous
    func previous() {
        let previousTag: Int = self.currentTextFieldTag - 1
        
        if let textField: UITextField = self.view.viewWithTag(previousTag) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            self.done()
        }
    }
    
    //MARK: - Next
    func next() {
        let nextTag: Int = self.currentTextFieldTag + 1
        
        if let textField: UITextField = self.view.viewWithTag(nextTag) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            self.done()
        }
    }
    
    //MARK: - TextField Delegate
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
            self.login()
        }
        
        return true
    }
    
    //MARK: - Login Validation
    func login() {
        var errorMessage: String = ""
        
        if !self.emailAddressTextField.isNotEmpty() {
            errorMessage = LoginStrings.emailIsRequired
        } else if !self.emailAddressTextField.isValidEmail() {
            errorMessage = LoginStrings.invalidEmail
        } else if !self.passwordTextField.isNotEmpty() {
            errorMessage = LoginStrings.passwordIsRequired
        }
        self.view.endEditing(true)
        self.adjustTextFieldYInsetWithInset(0)
        if errorMessage != "" {
            self.view.makeToast(errorMessage, duration: 3.0, position: CSToastPositionBottom, style: CSToastManager.sharedStyle())
        } else {
            fireLogin()
        }
    }
    
    //MARK: - Fire Login
    func fireLogin() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = [LoginConstants.emailKey: self.emailAddressTextField.text, LoginConstants.passwordKey: self.passwordTextField.text, LoginConstants.clientIdKey: Constants.Credentials.clientID, LoginConstants.clientSecretKey: Constants.Credentials.clientSecret, LoginConstants.grantTypeKey: Constants.Credentials.grantBuyer]
        
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.hud?.hide(true)
                self.showSuccessMessage()
                self.fireCreateRegistration(SessionManager.gcmToken())
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                if let task = task.response as? NSHTTPURLResponse {
                    if error.userInfo != nil {
                        if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                            let errorDescription: String = jsonResult["error_description"] as! String
                            Toast.displayToastWithMessage(errorDescription, duration: 3.0, view: self.view)
                        }
                    }
                    
                    if task.statusCode == 401 {
                        Toast.displayToastWithMessage(LoginStrings.mismatch, duration: 3.0, view: self.view)
                    } else {
                        Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, duration: 3.0, view: self.view)
                    }
                    
                    self.hud?.hide(true)
                } else {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 3.0, view: self.view)
                }
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Fire Registration GCM
    func fireCreateRegistration(registrationID : String) {
        if(SessionManager.isLoggedIn()){
            let manager: APIManager = APIManager.sharedInstance
            let parameters: NSDictionary = [
                LoginConstants.registrationIdKey: "\(registrationID)",
                LoginConstants.accessTokenKey: SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
            
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println("Registration successful!")
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    println("Registration unsuccessful!")
            })
        }
    }
    
    //MARK: - Success Message
    func showSuccessMessage() {
        Toast.displayToastWithMessage( LoginStrings.successMessage, duration: 3.0, view: self.view)
        
        Delay.delayWithDuration(3.0, completionHandler: { (success) -> Void in
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        })
    }
    
    //MARK: - Adjust Y Inset
    func adjustTextFieldYInsetWithInset(inset: CGFloat) {
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.verticalSpaceConstraint.constant = inset
                self.parentViewController!.view.layoutIfNeeded()
                }, completion: {(value: Bool) in
                    
            })
        }
    }
    
    //MARK: - Hide Close Button
    func hideCloseButton() {
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.closeButton.alpha = 0
                }, completion: {(value: Bool) in
                    
            })
        }
    }
    //MARK: - Show Close Button
    func showCloseButton() {
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.closeButton.alpha = 1
                }, completion: {(value: Bool) in
                    
            })
        }
    }
    
    //MARK: - Get Facebook Profile Image
    func getProfileImage(userID: String) {
        SessionManager.setProfileImage("http://graph.facebook.com/\(userID)/picture?type=large")
    }
    
    //MARK: - Fire Facebook With Login
    func fireFacebookLoginWithToken(token: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [LoginConstants.tokenKey: token, LoginConstants.clientIdKey: Constants.Credentials.clientID, LoginConstants.clientSecretKey: Constants.Credentials.clientSecret, LoginConstants.grantTypeKey: Constants.Credentials.grantBuyer]
        
        manager.POST(APIAtlas.facebookUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            println(responseObject.description)
            
            let loginModel: LoginModel = LoginModel.parseDataFromDictionary(responseObject as! NSDictionary)
            if loginModel.isSuccessful {
                SessionManager.parseTokensFromResponseObject(loginModel.dataDictionary)
                self.showSuccessMessage()
            } else {
                FBSDKLoginManager().logOut()
                Toast.displayToastWithMessage(loginModel.message, view: self.view)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, view: self.view)
                self.hud?.hide(true)
        })
        
    }
    
    //MARK: - Fire GooglePlus With Login
    func fireGooglePlusLoginWithToken(token: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [LoginConstants.tokenKey: token, LoginConstants.clientIdKey: Constants.Credentials.clientID, LoginConstants.clientSecretKey: Constants.Credentials.clientSecret, LoginConstants.clientSecretKey: Constants.Credentials.grantBuyer]
        
        manager.POST(APIAtlas.googleUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            
            let loginModel: LoginModel = LoginModel.parseDataFromDictionary(responseObject as! NSDictionary)
            if loginModel.isSuccessful {
                SessionManager.parseTokensFromResponseObject(loginModel.dataDictionary)
                self.showSuccessMessage()
            } else {
                Toast.displayToastWithMessage(loginModel.message, view: self.view)
            }
            
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, view: self.view)
                self.hud?.hide(true)
        })
        
    }
    
    //MARK: - Facebook Logout
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
   
}
