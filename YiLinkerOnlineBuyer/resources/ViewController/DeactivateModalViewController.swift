//
//  DeactivateModalViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/21/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol DeactivateModalViewControllerDelegate {
    func closeDeactivateModal()
    func submitDeactivateModal(password: String)
}

class DeactivateModalViewController: UIViewController {
    
    var delegate: DeactivateModalViewControllerDelegate?
    
    let manager = APIManager.sharedInstance

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var mainViewOriginalFrame: CGRect?
    var screenHeight: CGFloat?
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
    }

    //MARK : Initialization
    func initializeViews() {
        self.mainView.layer.cornerRadius = 8
        self.submitButton.layer.cornerRadius = 5
        self.mainViewOriginalFrame = mainView.frame
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.screenHeight = screenSize.height
        
        self.topConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func tapMainAction() {
        self.passwordTextField.resignFirstResponder()
        self.topConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    //MARK: - Util Functions
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topConstraint.constant = screenHeight! / 5
        }
    }

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeDeactivateModal()
        } else if sender as! UIButton == self.submitButton {
            self.tapMainAction()
            if self.passwordTextField.isNotEmpty() {
                self.fireDeactivateAccount(passwordTextField.text)
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("PASSWORD_IS_REQUIRED_LOCALIZE_KEY"))
            }
        }
    }
    
    //MARK: -
    //MARK: - Util Functions
    
    //MARK: Loader function
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
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    //MARK: -
    //MARK: - API Request
    
    //MARK: - Fire Post Settings
    /* Function called when access_token is already expired.
    * (Parameter) type: NotificationType -- Type of notification(SMS or Email) needed to identify
    *                                        the url to be used for the API request
    *             isON: Bool -- Requested status of the choosen 'NotificationType'
    *
    * This function is for requesting of to update the current of the choosen notification.
    * (ALlow to be notified or not)
    *
    * At first it will check the 'NotificationType' to identify the url to be used for the API request.
    *
    * If the API request is unsuccessful, it will check the r'equestErrorType'
    * and execute/do action/s  based on the error type)
    */
    func fireDeactivateAccount(password: String) {
        self.showLoader()
        var url: String = APIAtlas.deactivate
        
        WebServiceManager.fireDeactivateWithUrl(url, accessToken: SessionManager.accessToken(), password: password) { (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            println(responseObject)
            if successful{
                if let dictionary: NSDictionary = responseObject as? NSDictionary {
                    if let isSuccessful: Bool = dictionary["isSuccessful"] as? Bool {
                        if isSuccessful {
                            self.delegate?.submitDeactivateModal(self.passwordTextField.text)
                            self.dismissLoader()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            if let message: String = dictionary["message"] as? String {
                                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: message)
                            }
                        }
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                    }
                }
            }
            else{
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    
                    if errorModel.message == "The access token provided is invalid." {
                        UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                        })
                    } else {
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    }
                    
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(password)
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
        }
    }
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) type: NotificationType -- Type of notification(SMS or Email) needed to identify
    *                                        the url to be used for the API request
    *             isON: Bool -- Requested status of the choosen 'NotificationType'
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(password: String) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireDeactivateAccount(password)
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
}
