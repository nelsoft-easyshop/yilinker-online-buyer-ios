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
    @IBOutlet weak var referralCodeTextField: UITextField!
    
    @IBOutlet weak var registerButton: DynamicRoundedButton!
    
    var currentTextFieldTag: Int = 1
    var hud: MBProgressHUD?
    
    @IBOutlet weak var orLabel: UILabel!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            self.done()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.needsUpdateConstraints()
        self.view.layoutIfNeeded()
        self.setUpTextFields()
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
            self.passwordTextField.enabled = false
            self.reTypePasswordTextField.enabled = false
            
            self.mobileNumberTextField.enabled = false
            self.referralCodeTextField.enabled = false
        }
    }
    
    // MARK: Populate Default Data
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func setUpTextFields() {
        self.firstNameTextField.delegate = self
        self.firstNameTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.lastNameTextField.delegate = self
        self.lastNameTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.emailAddressTextField.delegate = self
        self.emailAddressTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.passwordTextField.delegate = self
        self.passwordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.reTypePasswordTextField.delegate = self
        self.reTypePasswordTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.mobileNumberTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.mobileNumberTextField.delegate = self
        self.referralCodeTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.referralCodeTextField.delegate = self
    }
    
    
    // Mark: - Done
    func done() {
        self.view.endEditing(true)
        self.showCloseButton()
        self.adjustTextFieldYInsetWithInset(0)
    }
    
    // Mark: - Previous
    func previous() {
        let previousTag: Int = self.currentTextFieldTag - 1
       
        if let textField: UITextField = self.view.viewWithTag(previousTag) as? UITextField {
            textField.becomeFirstResponder()
        } else {
            self.done()
        }

    }
    
    // Mark: - Next
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
        let textFieldHeightWithInset: CGFloat = -30
        if IphoneType.isIphone6Plus() {
            if textField == self.referralCodeTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset - 55)
            }
        } else if IphoneType.isIphone6() {
            if textField == self.mobileNumberTextField || textField == self.referralCodeTextField || textField == self.reTypePasswordTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset + CGFloat((textField.tag - 5) * -55))
            }
        } else if IphoneType.isIphone5() {
            if textField == self.mobileNumberTextField || textField == self.referralCodeTextField || textField == self.reTypePasswordTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset + CGFloat((textField.tag - 5) * -45))
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
    
    func register() {
        var errorMessage: String = ""
        
        if !self.firstNameTextField.isNotEmpty() {
            errorMessage = RegisterStrings.firstNameRequired
        } else if !self.firstNameTextField.isValidName() {
            errorMessage = RegisterStrings.illegalFirstName
        } else if !self.lastNameTextField.isNotEmpty() {
            errorMessage = RegisterStrings.lastNameRequired
        } else if !self.lastNameTextField.isValidName() {
            errorMessage = RegisterStrings.invalidLastName
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
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorMessage)
        } else {
            self.fireRegister()
        }
    }
    
    func hideCloseButton() {
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.closeButton.alpha = 0
                }, completion: {(value: Bool) in
                    
            })
        }
    }
    
    func showCloseButton() {
        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
                parentViewController.closeButton.alpha = 1
                }, completion: {(value: Bool) in
                    
            })
        }
    }
    
    func fireRegister() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance

        var parameters: NSDictionary?
        
        let loginRegisterParentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
        
        var url: String = ""
        
        if loginRegisterParentViewController.registerModel.firstName == "" {
            url = APIAtlas.registerUrl
            parameters = ["email": self.emailAddressTextField.text,"password": self.passwordTextField.text, "firstName": self.firstNameTextField.text, "lastName": self.lastNameTextField.text, "contactNumber": self.mobileNumberTextField.text]
        } else {
            url = APIAtlas.guestUserRegisterUrl
            parameters = ["user_guest[plainPassword][first]": self.passwordTextField.text, "user_guest[plainPassword][second]": self.passwordTextField.text, "user_guest[referralCode]" : self.referralCodeTextField.text]
        }
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                if registerModel.isSuccessful {
                    self.fireLogin(self.emailAddressTextField.text, password: self.passwordTextField.text, firstName: self.firstNameTextField.text, lastName: self.lastNameTextField.text)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: registerModel.message, title: "Error")
                     self.hud?.hide(true)
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
    
                if !Reachability.isConnectedToNetwork() {
                    UIAlertController.displayNoInternetConnectionError(self)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
                
                self.hud?.hide(true)
        })
    }
    
    func fireLogin(email: String, password: String, firstName: String, lastName: String) {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["email": self.emailAddressTextField.text,"password": self.passwordTextField.text, "client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantBuyer]
        self.showHUD()
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            self.showSuccessMessage()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                self.hud?.hide(true)
        })
    }
    
    func showSuccessMessage() {
        let alertController = UIAlertController(title: RegisterStrings.thankyou, message: RegisterStrings.successRegister, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
}