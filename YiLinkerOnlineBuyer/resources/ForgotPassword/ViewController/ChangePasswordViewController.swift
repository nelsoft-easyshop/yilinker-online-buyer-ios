//
//  ChangePasswordViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangePasswordViewControllerDelegate {
    func closeChangePasswordViewController()
    func submitChangePasswordViewController()
}

class ChangePasswordViewController: UIViewController {
    
    var delegate: ChangePasswordViewControllerDelegate?

    let manager = APIManager.sharedInstance
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!

    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var mobileNumber: String = ""
    
    var hud: MBProgressHUD?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.initializeLocalizedString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Initializations
    func initializeViews() {
        self.mainView.layer.cornerRadius = 8
        self.submitButton.layer.cornerRadius = 5
        self.mainViewOriginalFrame = mainView.frame
        
        // Add tap event to Sort View
        var viewType = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
        self.tapView.addGestureRecognizer(viewType)
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.screenHeight = screenSize.height
        
        self.topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        self.errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        self.somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        self.connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        self.connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        
        var changePasswordLocalizeString = StringHelper.localizedStringWithKey("CHANGEPASSWORD_LOCALIZE_KEY")
        var oldPasswordLocalizeString = StringHelper.localizedStringWithKey("OLDPASSWORD_LOCALIZE_KEY")
        var newPasswordLocalizeString = StringHelper.localizedStringWithKey("NEWPASSWORD_LOCALIZE_KEY")
        var confirmPasswordLocalizeString = StringHelper.localizedStringWithKey("CONFIRMPASSWORD_LOCALIZE_KEY")
        var submitLocalizeString = StringHelper.localizedStringWithKey("SUBMIT_LOCALIZE_KEY")
        
        self.submitButton.setTitle(submitLocalizeString, forState: UIControlState.Normal)
        
        self.titleLabel.text = changePasswordLocalizeString
        self.oldPasswordLabel.text = oldPasswordLocalizeString
        self.newPasswordLabel.text = newPasswordLocalizeString
        self.confirmPasswordLabel.text = confirmPasswordLocalizeString
    }
    
    //MARK - IBActions
        @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            self.topMarginConstraint.constant = screenHeight! / 10
        }
        else if IphoneType.isIphone6() {
            self.topMarginConstraint.constant = screenHeight! / 4
        }
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.closeChangePasswordViewController()
        } else if sender as! UIButton == self.submitButton {
            tapMainAction()
            if self.oldPasswordTextField.text.isEmpty || self.newPasswordTextField.text.isEmpty || self.confirmPasswordTextField.text.isEmpty {
                var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: completeLocalizeString)
            } else if self.newPasswordTextField.text != self.confirmPasswordTextField.text {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("PASSWORDMISMATCH_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordLocalizeString)
            } else if !self.newPasswordTextField.isAlphaNumeric() {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("ILLEGAL_PASSWORD_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordLocalizeString)
            } else if !self.newPasswordTextField.isValidPassword() {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("NUMBER_LETTERS_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: passwordLocalizeString)
            } else {
                self.fireChangePassword(self.oldPasswordTextField.text, newPassword: self.newPasswordTextField.text)
            }
        }
    }
    
    //MARK - Util Fucntion
    
    func tapMainViewAction() {
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            if topMarginConstraint.constant == screenHeight! / 10 ||  topMarginConstraint.constant == self.screenHeight! / 4 {
                self.tapMainAction()
            } else {
                self.buttonAction(closeButton)
            }
        } else {
            self.buttonAction(closeButton)
        }
    }
    
    func tapMainAction() {
        self.oldPasswordTextField.resignFirstResponder()
        self.newPasswordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
        
        self.topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    //Loader function
    func showLoader() {
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
    
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    //MARK: API Requests
    func fireChangePassword(oldPassword: String, newPassword: String) {
        self.showLoader()
        WebServiceManager.fireChangePassword(APIAtlas.changePassword, accessToken: SessionManager.accessToken(), oldPassword: oldPassword, newPassword: newPassword, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                if let isSuccessful: Bool = responseObject["isSuccessful"] as? Bool {
                    if isSuccessful {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.delegate?.submitChangePasswordViewController()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
                    }
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(oldPassword, newPassword: newPassword)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) params: TemporaryParameters -- collection of all params
    * needed by all API request in the Wishlist.
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(oldPassword: String, newPassword: String) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireChangePassword(oldPassword, newPassword: newPassword)
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
}
