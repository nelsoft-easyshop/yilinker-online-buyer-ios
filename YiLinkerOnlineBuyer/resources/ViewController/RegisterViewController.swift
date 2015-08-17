//
//  RegisterViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var reTypePasswordTextField: UITextField!
    @IBOutlet weak var registerButton: DynamicRoundedButton!
    
    var currentTextFieldTag: Int = 1
    
    
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
        self.registerButton.addTarget(self, action: "fireRegister", forControlEvents: UIControlEvents.TouchUpInside)
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
    }
    
    func done() {
        self.view.endEditing(true)
        self.showCloseButton()
        self.adjustTextFieldYInsetWithInset(0)
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
        let textFieldHeightWithInset: CGFloat = -30
        if IphoneType.isIphone6Plus() {
            if textField == self.passwordTextField || textField == self.reTypePasswordTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset)
            } else {
                self.adjustTextFieldYInsetWithInset(0)
            }
        } else if IphoneType.isIphone6() {
            if textField == self.firstNameTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset)
            } else if textField == self.lastNameTextField {
                self.adjustTextFieldYInsetWithInset(textFieldHeightWithInset)
            } else if textField == self.emailAddressTextField {
                self.adjustTextFieldYInsetWithInset(CGFloat(textField.tag) * textFieldHeightWithInset)
            } else {
                self.adjustTextFieldYInsetWithInset(3 * textFieldHeightWithInset)
            }
        } else if IphoneType.isIphone5() {
            if textField == self.firstNameTextField || textField == self.lastNameTextField {
                self.showCloseButton()
                self.adjustTextFieldYInsetWithInset(0)
            } else if textField == self.emailAddressTextField {
                self.showCloseButton()
                self.adjustTextFieldYInsetWithInset(-50)
            } else if textField == self.passwordTextField  || textField == self.reTypePasswordTextField {
                self.hideCloseButton()
                self.adjustTextFieldYInsetWithInset(-70)
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
        if textField.tag != 5 {
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
            errorMessage = "First name is required."
        } else if !self.firstNameTextField.isAlphaNumeric() {
            errorMessage = "First name contains illegal characters. It can only contain letters, numbers and underscores."
        } else if !self.lastNameTextField.isNotEmpty() {
            errorMessage = "Last name is required."
        } else if !self.lastNameTextField.isAlphaNumeric() {
            errorMessage = "Last name contains illegal characters. It can only contain letters, numbers and underscores."
        } else if !self.emailAddressTextField.isNotEmpty() {
            errorMessage = "Email is required."
        } else if !self.emailAddressTextField.isValidEmail() {
            errorMessage = "The email address you enter is not a valid email address."
        } else if !self.passwordTextField.isNotEmpty() {
            errorMessage = "Password is required."
        } else if !self.passwordTextField.isAlphaNumeric() {
            errorMessage = "Password contains illegal characters. It can only contain letters, numbers and underscores."
        } else if !self.reTypePasswordTextField.isNotEmpty() {
            errorMessage = "Re-type password is required."
        } else if self.passwordTextField.text != self.passwordTextField.text {
            errorMessage = "The password does not match."
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
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager: APIManager = APIManager.sharedInstance

        let parameters: NSDictionary = ["email": self.emailAddressTextField.text,"password": self.passwordTextField.text, "fullname": "\(self.firstNameTextField.text) \(self.lastNameTextField.text)"]
        
        manager.GET(APIAtlas.registerUrl, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
                if registerModel.isSuccessful {
                    SVProgressHUD.dismiss()
                    println(responseObject)
                    self.showSuccessMessage()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: registerModel.message, title: "Error")
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if !Reachability.isConnectedToNetwork() {
                    UIAlertController.displayNoInternetConnectionError(self)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                SVProgressHUD.dismiss()
        })
    }
    
    func showSuccessMessage() {
        let alertController = UIAlertController(title: "Success", message: "Successfully login.", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
}
