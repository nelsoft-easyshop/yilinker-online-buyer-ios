//
//  RegisterViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


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

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    //@IBOutlet weak var referralCodeTextField: UITextField!
    
    @IBOutlet weak var registerButton: DynamicRoundedButton!
    
    var currentTextFieldTag: Int = 1
    var hud: MBProgressHUD?
    
    var yAdjustment: CGFloat = 0
    
    var mainViewGesture: UITapGestureRecognizer?
    
    @IBOutlet weak var orLabel: UILabel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
        
        if !parentViewController.isFromTab && IphoneType.isIphone5() {
            yAdjustment = 25
        } else if IphoneType.isIphone5() {
            yAdjustment = -15
        } else {
            yAdjustment = 15
        }
        
        parentViewController.verticalSpaceConstraint.constant = yAdjustment
        self.parentViewController?.view.addGestureRecognizer(mainViewGesture!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.needsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.setUpTextFields()
        self.roundRegisterButton()
        
        self.registerButton.addTarget(self, action: "register", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.firstNameTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.firstName)
        self.lastNameTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.lastName)
        self.emailAddressTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.emailAddress)
        self.passwordTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.password)
        self.reTypePasswordTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.reTypePassword)
        self.mobileNumberTextField.attributedPlaceholder = StringHelper.required(RegisterStrings.mobileNumber)
        
        self.registerButton.setTitle(RegisterStrings.registerMeNow, forState: UIControlState.Normal)
        self.registerButton.setTitle(RegisterStrings.registerMeNow, forState: UIControlState.Normal)
        
        self.populateDefautData()
       
        let loginRegisterParentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
        if loginRegisterParentViewController.registerModel.firstName != "" {
            self.firstNameTextField.enabled = false
            self.lastNameTextField.enabled = false
            self.emailAddressTextField.enabled = false
//            self.passwordTextField.enabled = false
//            self.reTypePasswordTextField.enabled = false
            
            self.mobileNumberTextField.enabled = false
            //self.referralCodeTextField.enabled = false
        }
        
        let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
        if !parentViewController.isFromTab && IphoneType.isIphone5() {
            parentViewController.verticalSpaceConstraint.constant = yAdjustment
        }
        
        mainViewGesture = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.parentViewController?.view.removeGestureRecognizer(mainViewGesture!)
    }
    
    //MARK: Tap Main View
    func tapMainViewAction() {
        self.view.endEditing(true)
        
        if IphoneType.isIphone5() {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        } else if IphoneType.isIphone6() {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        } else if IphoneType.isIphone6Plus() {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        } else {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        }
    }
    
    //MARK: - Round Register Button
    func roundRegisterButton() {
        self.registerButton.layer.cornerRadius = 5
        self.registerButton.clipsToBounds = true
    }
    
    //MARK: Populate Default Data
    func populateDefautData() {
        let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
        
        self.firstNameTextField.text = parentViewController.registerModel.firstName
        self.lastNameTextField.text = parentViewController.registerModel.lastName
        self.emailAddressTextField.text = parentViewController.registerModel.emailAddress
        self.mobileNumberTextField.text = parentViewController.registerModel.mobileNumber
    }
    
    //Show HUD
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
    
    //MARK: - Setup TextFields
    func setUpTextFields() {
        self.firstNameTextField.delegate = self
        //self.firstNameTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.lastNameTextField.delegate = self
        //self.lastNameTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.emailAddressTextField.delegate = self
        //self.emailAddressTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.passwordTextField.delegate = self
        //self.passwordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.reTypePasswordTextField.delegate = self
        //self.reTypePasswordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.mobileNumberTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.mobileNumberTextField.delegate = self
        //self.referralCodeTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        //self.referralCodeTextField.delegate = self
    }
    
    
    //MARK: - Done
    func done() {
        self.view.endEditing(true)
        self.showCloseButton()
       
        let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
        
        if IphoneType.isIphone5() && !parentViewController.isFromTab {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        } else if IphoneType.isIphone6() {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        } else if IphoneType.isIphone6Plus() {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        } else {
            self.adjustTextFieldYInsetWithInset(yAdjustment)
        }
        
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
        let textFieldHeightWithInset: CGFloat = -30
        if IphoneType.isIphone6Plus() {
            if textField == self.mobileNumberTextField  {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                if parentViewController.isFromTab {
                    self.adjustTextFieldYInsetWithInset(-20)
                } else {
                    self.adjustTextFieldYInsetWithInset(-10)
                }
                
                textField.autocorrectionType = .No
            }
        } else if IphoneType.isIphone6() {
            if textField == self.mobileNumberTextField || textField == self.reTypePasswordTextField {
                var x: Int = 0
                /*if textField == self.referralCodeTextField {
                    x = (textField.tag - 1)
                    textField.autocorrectionType = .No
                } else {
                    x = textField.tag
                }*/
                
                x = textField.tag
                
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset + CGFloat(x - 5) * -55)
            }
        } else if IphoneType.isIphone5() {
            let parent: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
            if parent.isFromTab {
                if textField == self.mobileNumberTextField || textField == self.reTypePasswordTextField || textField == self.passwordTextField {
                    self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset + CGFloat((textField.tag - 3) * -40))
                }
            } else {
                if textField == self.mobileNumberTextField || textField == self.reTypePasswordTextField {
                    self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset + CGFloat((textField.tag - 5) * -45))
                }
            }
            
            
        } else if IphoneType.isIphone4() {
            self.hideCloseButton()
            if textField == self.firstNameTextField || textField == self.lastNameTextField {
                self.adjustTextFieldYInsetWithInset(-50)
            } else  {
                if textField.tag != 5 {
                    self.adjustTextFieldYInsetWithInset(CGFloat(textField.tag) * textFieldHeightWithInset)
                } else {
                    self.adjustTextFieldYInsetWithInset(CGFloat(textField.tag - 1) * textFieldHeightWithInset)
                }
            }
        }
    
        
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag != 6 {
            self.next()
        } else {
            self.done()
            self.register()
        }
        
        return true
    }
    
    //MARK: - Adjust Text Field Y Inset With Inset
    func adjustTextFieldYInsetWithInset(inset: CGFloat) {
        //Code for adjusting view above the keyboard
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.verticalSpaceConstraint.constant = inset
                self.parentViewController!.view.layoutIfNeeded()
                }, completion: {(value: Bool) in
                    
            })
        }
    }
    
    //MARK: - Register
    func register() {
        var errorMessage: String = ""
        //validate fields
        if !self.firstNameTextField.isNotEmpty() {
            errorMessage = RegisterStrings.firstNameRequired
        } else if !self.lastNameTextField.isNotEmpty() {
            errorMessage = RegisterStrings.lastNameRequired
        } else if !self.emailAddressTextField.isNotEmpty() {
            errorMessage = RegisterStrings.emailRequired
        } else if !self.emailAddressTextField.isValidEmail() {
            errorMessage = RegisterStrings.invalidEmail
        } else if !self.passwordTextField.isNotEmpty() {
            errorMessage = RegisterStrings.passwordRequired
        } else if !self.passwordTextField.isAlphaNumeric() {
            errorMessage = RegisterStrings.illegalPassword
        } else if !self.passwordTextField.isValidPassword() {
            errorMessage = RegisterStrings.numbersAndLettersOnly
        } else if !self.passwordTextField.isGreaterThanEightCharacters() {
            errorMessage = RegisterStrings.eightCharacters
        } else if !self.reTypePasswordTextField.isNotEmpty() {
            errorMessage = RegisterStrings.reTypePasswordError
        } else if self.passwordTextField.text != self.reTypePasswordTextField.text {
            errorMessage = RegisterStrings.passwordNotMatch
        } else if self.mobileNumberTextField.text == "" {
            errorMessage = RegisterStrings.contactRequired
        } 
        
        if errorMessage != "" {
            Toast.displayToastWithMessage(errorMessage, duration: 1.5, view: self.view)
        } else {
            self.showHUD()
            
            let loginRegisterParentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
            //check if the user is guest or not
            if loginRegisterParentViewController.registerModel.firstName == "" {
                //user is not guests
                WebServiceManager.fireRegisterRequestWithUrl(APIAtlas.registerUrl, emailAddress: self.emailAddressTextField.text,
                    mobileNumber: self.mobileNumberTextField.text, password: self.passwordTextField.text,
                    firstName: self.firstNameTextField.text, lastName: self.lastNameTextField.text,
                    actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                        if successful {
                            self.hud?.hide(true)
                            let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                            if registerModel.isSuccessful {
                                self.fireLogin(self.emailAddressTextField.text, password: self.passwordTextField.text)
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
                WebServiceManager.fireGuestRegisterRequestWithUrl(APIAtlas.guestUserRegisterUrl, password: self.passwordTextField.text, referralCode: "", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                    if successful {
                        self.hud?.hide(true)
                        let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                        if registerModel.isSuccessful {
                            //Login User after successfully registered
                            self.fireLogin(self.emailAddressTextField.text, password: self.passwordTextField.text)
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
    
    //MARK: - Fire Login
    func fireLogin(email: String, password: String) {
        WebServiceManager.fireLoginRequestWithUrl(APIAtlas.loginUrl, emailAddress: email, password: password, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                //Save access token and refresh token to session manager
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.hud?.hide(true)
                //Show success message and redirect to homepage
                self.showSuccessMessage()
                self.fireCreateRegistration(SessionManager.gcmToken())
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    let jsonError: NSDictionary = responseObject as! NSDictionary
                    let errorDescription: String = jsonError["error_description"] as! String
                    Toast.displayToastWithMessage(errorDescription, duration: 1.5, view: self.view)
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
    
    //MARK: - Show Success Message
    func showSuccessMessage() {
        Toast.displayToastWithMessage(RegisterStrings.successRegister, duration: 1.5, view: self.view)
        self.view.userInteractionEnabled = false
        
        Delay.delayWithDuration(1.5, completionHandler: { (success) -> Void in
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        })
    }
    
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
}