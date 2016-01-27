//
//  LoginAndRegisterTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/26/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

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
    static let forgotPasswordUrlString = APIEnvironment.baseUrl().stringByReplacingOccurrencesOfString("/api", withString: "/") + "forgot-password-request"
    
    static let emailKey = "email"
    static let passwordKey = "password"
    static let clientIdKey = "client_id"
    static let clientSecretKey = "client_secret"
    static let grantTypeKey = "grant_type"
    
    static let registrationIdKey = "registrationId"
    static let accessTokenKey = "access_token"
    
    static let tokenKey = "token"
}

struct RegisterStrings {
    static let firstName: String = StringHelper.localizedStringWithKey("FIRST_NAME_LOCALIZE_KEY")
    static let lastName: String = StringHelper.localizedStringWithKey("LAST_NAME_LOCALIZE_KEY")
    static let emailAddress: String = StringHelper.localizedStringWithKey("EMAIL_ADDRESS_LOCALIZE_KEY")
    static let password: String = StringHelper.localizedStringWithKey("PASSWORD_LOCALIZE_KEY")
    
    static let mobileNumber: String = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
    static let referral: String = StringHelper.localizedStringWithKey("REFERRAL_LOCALIZED_KEY")
    
    static let reTypePassword: String = StringHelper.localizedStringWithKey("RE_TYPE_PASSWORD_LOCALIZE_KEY")
    static let registerMeNow: String = StringHelper.localizedStringWithKey("REGISTER_ME_NOW_LOCALIZE_KEY")
    
    static let firstNameRequired: String = StringHelper.localizedStringWithKey("FIRST_NAME_REQUIRED_LOCALIZE_KEY")
    static let illegalFirstName: String = StringHelper.localizedStringWithKey("FIRST_NAME_ILLEGAL_LOCALIZE_KEY")
    static let lastNameRequired: String = StringHelper.localizedStringWithKey("LAST_NAME_REQUIRED_LOCALIZE_KEY")
    static let invalidLastName: String = StringHelper.localizedStringWithKey("INVALID_LAST_NAME_LOCALIZE_KEY")
    static let emailRequired: String = StringHelper.localizedStringWithKey("EMAIL_REQUIRED_LOCALIZE_KEY")
    
    static let invalidEmail: String = StringHelper.localizedStringWithKey("INVALID_EMAIL_LOCALIZE_KEY")
    static let passwordRequired: String = StringHelper.localizedStringWithKey("PASSWORD_REQUIRED_LOCALIZE_KEY")
    static let illegalPassword: String = StringHelper.localizedStringWithKey("ILLEGAL_PASSWORD_LOCALIZE_KEY")
    static let reTypePasswordError: String = StringHelper.localizedStringWithKey("RETYPE_REQUIRED_LOCALIZE_KEY")
    static let passwordNotMatch: String = StringHelper.localizedStringWithKey("PASSWORD_NOT_MATCH_LOCALIZE_KEY")
    static let contactRequired: String = StringHelper.localizedStringWithKey("CONTACT_REQUIRED_LOCALIZE_KEY")
    static let numbersAndLettersOnly: String = StringHelper.localizedStringWithKey("NUMBER_LETTERS_LOCALIZE_KEY")
    static let successRegister: String = StringHelper.localizedStringWithKey("SUCCESS_REGISTER_LOCALIZED_KEY")
    static let thankyou: String = StringHelper.localizedStringWithKey("THANKYOU_LOCALIZED_KEY")
    
    static let eightCharacters: String = StringHelper.localizedStringWithKey("EIGHT_CHARACTERS_LOCALIZED_KEY")
}

class LoginAndRegisterTableViewController: UITableViewController, LoginHeaderTableViewCellDelegate, LoginTableViewCellDelegate, RegisterTableViewCellDelegate {
    
    let headerViewNibName = "LoginHeaderTableViewCell"
    let loginTableViewCellNibName = "LoginTableViewCell"
    let registerTableViewCellNibName = "RegisterTableViewCell"

    let loginCellHeight: CGFloat = 230
    let registerCellHeight: CGFloat = 250
    
    var hud: MBProgressHUD?
    
    var loginSessionDataTask: NSURLSessionDataTask = NSURLSessionDataTask()
    
    var isHideCloseButton: Bool = false
    var isGuestUser: Bool = false
    var isLogin: Bool = true
    
    var registerModel: RegisterModel = RegisterModel()
    
    //MARK: - 
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCellWithIdentifier(self.headerViewNibName)
        self.registerCellWithIdentifier(self.loginTableViewCellNibName)
        self.registerCellWithIdentifier(self.registerTableViewCellNibName)
        
        self.tableView.tableHeaderView = self.headerView()
        self.tableView.tableFooterView = self.footerView()
        self.tableView.separatorColor = .clearColor()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
        } else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.isLogin {
            let loginTableViewCell: LoginTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.loginTableViewCellNibName) as! LoginTableViewCell
            loginTableViewCell.selectionStyle = .None
            loginTableViewCell.delegate = self
            return loginTableViewCell
        } else {
            let registerTableViewCell: RegisterTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.registerTableViewCellNibName) as! RegisterTableViewCell
            registerTableViewCell.selectionStyle = .None
            registerTableViewCell.delegate = self
            
            if self.isGuestUser {
                registerTableViewCell.firstNameTextField.enabled = false
                registerTableViewCell.lastNameTextField.enabled = false
                registerTableViewCell.emailAddressTextField.enabled = false
                registerTableViewCell.mobileNumberTextField.enabled = false
                
                registerTableViewCell.firstNameTextField.text = self.registerModel.firstName
                registerTableViewCell.lastNameTextField.text = self.registerModel.lastName
                registerTableViewCell.emailAddressTextField.text = self.registerModel.emailAddress
                registerTableViewCell.mobileNumberTextField.text = self.registerModel.mobileNumber
            }
            
            return registerTableViewCell
        }
    }
  
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.isLogin {
            return self.loginCellHeight
        } else {
            return self.registerCellHeight
        }
    }
    
    //MARK: - 
    //MARK: - Header View
    func headerView() -> LoginHeaderTableViewCell {
        let loginHeaderView: LoginHeaderTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.headerViewNibName) as! LoginHeaderTableViewCell
        loginHeaderView.delegate = self
        
        if self.isHideCloseButton {
            loginHeaderView.crossOutButton.hidden = true
        }
        
        if self.isLogin {
            loginHeaderView.activateButton(loginHeaderView.loginButton)
            loginHeaderView.deActivateButton(loginHeaderView.registerButton)
        } else {
            loginHeaderView.activateButton(loginHeaderView.registerButton)
            loginHeaderView.deActivateButton(loginHeaderView.loginButton)
        }
        
        return loginHeaderView
    }
    
    //MARK: - 
    //MARK: - Footer View
    func footerView() -> UIView {
        let footerView: UIView = UIView(frame: CGRectZero)
        return footerView
    }
    
    //MARK: - 
    //MARK: - Register Cell With Identifier
    func registerCellWithIdentifier(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: nibName)
    }
    
    //MARK: - 
    //MARK: - Get Facebook Access Token
    func getFaceBookAccessToken() -> String {
        var accessToken = FBSDKAccessToken.currentAccessToken().tokenString
        return accessToken
    }
    
    //MARK: -
    //MARK: - Fire Registration GCM
    func fireCreateRegistration(registrationID : String) {
        if(SessionManager.isLoggedIn()){
            let manager: APIManager = APIManager.sharedInstance
            let parameters: NSDictionary = [
                
                "registrationId": "\(registrationID)",
                "access_token"  : SessionManager.accessToken(),
                "deviceType"    : "1"
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
    
    //MARK: -
    //MARK: - Success Message
    func showSuccessMessage() {
        Toast.displayToastWithMessage( LoginStrings.successMessage, duration: 3.0, view: self.view)
        self.view.userInteractionEnabled = false
        Delay.delayWithDuration(1.0, completionHandler: { (success) -> Void in
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        })
    }
    
    //MARK: -
    //MARK: - Show HUD
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
    
    //MARK: -
    //MARK: - Login HeaderTable View Cell Delegate
    func loginHeaderTableViewCell(loginHeaderTableViewCell: LoginHeaderTableViewCell, didTapButton button: UIButton) {
        if button == loginHeaderTableViewCell.loginButton {
            self.isLogin = true
        } else if button == loginHeaderTableViewCell.registerButton {
            self.isLogin = false
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: -
    //MARK: - Login Table View Cell Delegate
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, textFieldShouldReturn textField: UITextField) {
        if textField == loginTableViewCell.emailTextField {
            loginTableViewCell.passwordTextField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            
            var errorMessage: String = ""
            
            if !loginTableViewCell.emailTextField.isNotEmpty() {
                errorMessage = LoginStrings.emailIsRequired
            } else if !loginTableViewCell.emailTextField.isValidEmail() {
                errorMessage = LoginStrings.invalidEmail
            } else if !loginTableViewCell.passwordTextField.isNotEmpty() {
                errorMessage = LoginStrings.passwordIsRequired
            }
            
            
            if errorMessage != "" {
                Toast.displayToastWithMessage(errorMessage, duration: 1.5, view: self.view)
            } else {
                self.fireLoginWithEmail(loginTableViewCell.emailTextField.text, password: loginTableViewCell.passwordTextField.text)
            }
        }
    }
    
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, didTapSignIn signInButton: UIButton) {
        self.fireLoginWithEmail(loginTableViewCell.emailTextField.text, password: loginTableViewCell.passwordTextField.text)
    }
    
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, didTapSuccessOnFacebookSignIn facebookButton: UIButton) {
        self.fireFacebookLoginWithToken(self.getFaceBookAccessToken())
    }
    
    func loginTableViewCell(loginTableViewCell: LoginTableViewCell, didTapForgotPassword forgotPasswordButton: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: LoginConstants.forgotPasswordUrlString)!)
    }
    
    //MARK: -
    //MARK: - Fire Login With Email
    func fireLoginWithEmail(email: String, password: String) {
        self.showHUD()
        self.loginSessionDataTask = WebServiceManager.fireLoginRequestWithUrl(APIAtlas.loginUrl, emailAddress: email, password: password, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.hud?.hide(true)
                self.showSuccessMessage()
                self.fireCreateRegistration(SessionManager.gcmToken())
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else if requestErrorType == .Cancel {
                    //Do nothing
                }
            }
        })
    }
    
    //MARK: -
    //MARK: - Fire Facebook With Login
    func fireFacebookLoginWithToken(token: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [LoginConstants.tokenKey: token, LoginConstants.clientIdKey: Constants.Credentials.clientID(), LoginConstants.clientSecretKey: Constants.Credentials.clientSecret(), LoginConstants.grantTypeKey: Constants.Credentials.grantBuyer]
        
        manager.POST(APIAtlas.facebookUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            println(responseObject.description)
            
            let loginModel: LoginModel = LoginModel.parseDataFromDictionary(responseObject as! NSDictionary)
            if loginModel.isSuccessful {
                SessionManager.parseTokensFromResponseObject(loginModel.dataDictionary)
                self.showSuccessMessage()
                self.fireCreateRegistration(SessionManager.gcmToken())
            } else {
                if let isExisting = loginModel.dataDictionary["isExisting"] as? Bool {
                    UIAlertController.showAlertYesOrNoWithTitle(Constants.Localized.error, message: "\(loginModel.message), do you want to merge your account?", viewController: self, actionHandler: { (isYes) -> Void in
                        if isYes {
                            self.mergeAccount(token)
                        } else {
                            FBSDKLoginManager().logOut()
                        }
                    })
                    
                } else {
                    FBSDKLoginManager().logOut()
                    Toast.displayToastWithMessage(loginModel.message, view: self.view)
                }
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, view: self.view)
                self.hud?.hide(true)
        })
    }
    
    //MARK: -
    //MARK: - Merge Account
    func mergeAccount(facebookAccessToken: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [LoginConstants.clientIdKey: Constants.Credentials.clientID(), LoginConstants.clientSecretKey: Constants.Credentials.clientSecret(), LoginConstants.clientSecretKey: Constants.Credentials.grantBuyer, "token": facebookAccessToken, "accountType": "facebook"]
        
        manager.POST(APIAtlas.mergeFacebook, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            
            let loginModel: LoginModel = LoginModel.parseDataFromDictionary(responseObject as! NSDictionary)
            if loginModel.isSuccessful {
                SessionManager.parseTokensFromResponseObject(loginModel.dataDictionary)
                self.showSuccessMessage()
                self.fireCreateRegistration(SessionManager.gcmToken())
            } else {
                FBSDKLoginManager().logOut()
                Toast.displayToastWithMessage(loginModel.message, view: self.view)
            }
            
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, view: self.view)
                self.hud?.hide(true)
        })
    }
    
    //MARK: - 
    //MARK: - Register Table View Cell Delegate
    func registerTableViewCell(registerTableViewCell: RegisterTableViewCell, textFieldShouldReturn textField: UITextField) {
        if textField != registerTableViewCell.mobileNumberTextField {
            for textField2 in registerTableViewCell.contentView.subviews {
                if textField2.isKindOfClass(UITextField) {
                    if textField2.tag == textField.tag + 1 {
                        textField2.becomeFirstResponder()
                        break
                    }
                }
            }
        } else {
            self.view.endEditing(true)
        }
    }
    
    func registerTableViewCell(registerTableViewCell: RegisterTableViewCell, didTapRegister button: UIButton) {
        self.view.endEditing(true)
        var errorMessage: String = ""
        //validate fields
        if !registerTableViewCell.firstNameTextField.isNotEmpty() {
            errorMessage = RegisterStrings.firstNameRequired
        } else if !registerTableViewCell.lastNameTextField.isNotEmpty() {
            errorMessage = RegisterStrings.lastNameRequired
        } else if !registerTableViewCell.emailAddressTextField.isNotEmpty() {
            errorMessage = RegisterStrings.emailRequired
        } else if !registerTableViewCell.emailAddressTextField.isValidEmail() {
            errorMessage = RegisterStrings.invalidEmail
        } else if !registerTableViewCell.passwordTextField.isNotEmpty() {
            errorMessage = RegisterStrings.passwordRequired
        } else if !registerTableViewCell.passwordTextField.isAlphaNumeric() {
            errorMessage = RegisterStrings.illegalPassword
        } else if !registerTableViewCell.passwordTextField.isValidPassword() {
            errorMessage = RegisterStrings.numbersAndLettersOnly
        } else if !registerTableViewCell.passwordTextField.isGreaterThanEightCharacters() {
            errorMessage = RegisterStrings.eightCharacters
        } else if !registerTableViewCell.reTypePasswordTextField.isNotEmpty() {
            errorMessage = RegisterStrings.reTypePasswordError
        } else if registerTableViewCell.passwordTextField.text != registerTableViewCell.reTypePasswordTextField.text {
            errorMessage = RegisterStrings.passwordNotMatch
        } else if registerTableViewCell.mobileNumberTextField.text == "" {
            errorMessage = RegisterStrings.contactRequired
        }
        
        if errorMessage != "" {
            Toast.displayToastWithMessage(errorMessage, duration: 1.5, view: self.view)
        } else {
            self.showHUD()
        
            //check if the user is guest or not
            if !self.isGuestUser {
                //user is not guests
                WebServiceManager.fireRegisterRequestWithUrl(APIAtlas.registerUrl, emailAddress: registerTableViewCell.emailAddressTextField.text,
                    mobileNumber: registerTableViewCell.mobileNumberTextField.text, password: registerTableViewCell.passwordTextField.text,
                    firstName: registerTableViewCell.firstNameTextField.text, lastName: registerTableViewCell.lastNameTextField.text,
                    actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                        if successful {
                            self.hud?.hide(true)
                            let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                            if registerModel.isSuccessful {
                                self.fireLoginWithEmail(registerTableViewCell.emailAddressTextField.text, password: registerTableViewCell.passwordTextField.text)
                            } else {
                                Toast.displayToastWithMessage(registerModel.message, duration: 2.0, view: self.view)
                            }
                        } else {
                            self.hud?.hide(true)
                            if requestErrorType == .ResponseError {
                                let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                                Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                            } else if requestErrorType == .PageNotFound {
                                Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                            } else if requestErrorType == .NoInternetConnection {
                                Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                            } else if requestErrorType == .RequestTimeOut {
                                Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                            } else if requestErrorType == .UnRecognizeError {
                                Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                            }
                        }
                })
            } else {
                //user is guest
                WebServiceManager.fireGuestRegisterRequestWithUrl(APIAtlas.guestUserRegisterUrl, password: registerTableViewCell.passwordTextField.text, referralCode: "", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                    if successful {
                        self.hud?.hide(true)
                        let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                        if registerModel.isSuccessful {
                            //Login User after successfully registered
                            self.fireLoginWithEmail(registerTableViewCell.emailAddressTextField.text, password: registerTableViewCell.passwordTextField.text)
                        } else {
                            Toast.displayToastWithMessage(registerModel.message, duration: 2.0, view: self.view)
                        }
                    } else {
                        self.hud?.hide(true)
                        if requestErrorType == .ResponseError {
                            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        } else if requestErrorType == .PageNotFound {
                            Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                        } else if requestErrorType == .NoInternetConnection {
                            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        } else if requestErrorType == .RequestTimeOut {
                            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        } else if requestErrorType == .UnRecognizeError {
                            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                        }
                    }
                })
            }
        }
    }
}