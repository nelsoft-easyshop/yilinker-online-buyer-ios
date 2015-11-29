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

        initializeViews()
        initializeLocalizedString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        mainView.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 5
        mainViewOriginalFrame = mainView.frame
        
        // Add tap event to Sort View
        var viewType = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
        self.tapView.addGestureRecognizer(viewType)
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        
        var changePasswordLocalizeString = StringHelper.localizedStringWithKey("CHANGEPASSWORD_LOCALIZE_KEY")
        var oldPasswordLocalizeString = StringHelper.localizedStringWithKey("OLDPASSWORD_LOCALIZE_KEY")
        var newPasswordLocalizeString = StringHelper.localizedStringWithKey("NEWPASSWORD_LOCALIZE_KEY")
        var confirmPasswordLocalizeString = StringHelper.localizedStringWithKey("CONFIRMPASSWORD_LOCALIZE_KEY")
        var submitLocalizeString = StringHelper.localizedStringWithKey("SUBMIT_LOCALIZE_KEY")
        
        submitButton.setTitle(submitLocalizeString, forState: UIControlState.Normal)
        
        titleLabel.text = changePasswordLocalizeString
        oldPasswordLabel.text = oldPasswordLocalizeString
        newPasswordLabel.text = newPasswordLocalizeString
        confirmPasswordLabel.text = confirmPasswordLocalizeString
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            topMarginConstraint.constant = screenHeight! / 10
        }
        else if IphoneType.isIphone6() {
            topMarginConstraint.constant = screenHeight! / 4
        }
    }
    
    func tapMainViewAction() {
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            if topMarginConstraint.constant == screenHeight! / 10 ||  topMarginConstraint.constant == screenHeight! / 4 {
                tapMainAction()
            } else {
                buttonAction(closeButton)
            }
        } else {
            buttonAction(closeButton)
        }
    }
    
    func tapMainAction() {
        oldPasswordTextField.resignFirstResponder()
        newPasswordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var okLocalizeString = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let defaultAction = UIAlertAction(title: okLocalizeString, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.closeChangePasswordViewController()
        } else if sender as! UIButton == submitButton {
            tapMainAction()
            if oldPasswordTextField.text.isEmpty ||  newPasswordTextField.text.isEmpty || confirmPasswordTextField.text.isEmpty {
                var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                showAlert(title: self.errorLocalizeString, message: completeLocalizeString)
            } else if newPasswordTextField.text != confirmPasswordTextField.text {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("PASSWORDMISMATCH_LOCALIZE_KEY")
                showAlert(title: self.errorLocalizeString, message: passwordLocalizeString)
            } else if !self.newPasswordTextField.isAlphaNumeric() {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("ILLEGAL_PASSWORD_LOCALIZE_KEY")
                showAlert(title: self.errorLocalizeString, message: passwordLocalizeString)
            } else if !self.newPasswordTextField.isValidPassword() {
                var passwordLocalizeString = StringHelper.localizedStringWithKey("NUMBER_LETTERS_LOCALIZE_KEY")
                showAlert(title: self.errorLocalizeString, message: passwordLocalizeString)
            } else {
                fireUpdateProfile(APIAtlas.changePassword, params: NSDictionary(dictionary: [
                    "access_token": SessionManager.accessToken(),
                    "oldPassword": oldPasswordTextField.text,
                    "newPassword": newPasswordTextField.text,
                    "newPasswordConfirm": confirmPasswordTextField.text]))
            }
        }
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
    
    func fireUpdateProfile(url: String, params: NSDictionary!) {
        showLoader()
        
        self.manager.responseSerializer = JSONResponseSerializer()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken(url, params: params)
            } else {
                if responseObject["isSuccessful"] as! Bool {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissLoader()
                    self.delegate?.submitChangePasswordViewController()
                } else {
                    self.showAlert(title: self.errorLocalizeString, message: responseObject["message"] as! String)
                    self.dismissLoader()
                }
            }
            println(responseObject)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                if Reachability.isConnectedToNetwork() {
                    var info = error.userInfo!
                    
                    self.dismissLoader()
                    
                    if let data = info["message"] as? NSString {
                        self.showAlert(title: self.errorLocalizeString, message: data as String)
                    } else {
                        self.showAlert(title: self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                    }
                    
                } else {
                    self.showAlert(title: self.connectionLocalizeString, message: self.connectionMessageLocalizeString)
                }
                
        })
        
    }
    
    func requestRefreshToken(url: String, params: NSDictionary!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireUpdateProfile(url, params: params)
            } else {
                self.showAlert(title: self.errorLocalizeString, message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissLoader()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(title: self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                
        })
    }
}
