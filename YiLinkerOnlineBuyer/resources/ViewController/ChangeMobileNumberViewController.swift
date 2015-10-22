//
//  ChangeMobileNumberViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangeMobileNumberViewControllerDelegate {
    func closeChangeNumbderViewController()
    func submitChangeNumberViewController()
}

class ChangeMobileNumberViewController: UIViewController {
    
    var delegate: ChangeMobileNumberViewControllerDelegate?
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var oldNumberTextField: UITextField!
    @IBOutlet weak var newNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var changeMobileLabel: UILabel!
    @IBOutlet weak var oldNumberLabel: UILabel!
    @IBOutlet weak var newNumberLabel: UILabel!
    @IBOutlet weak var oldNumberConstant: NSLayoutConstraint!
    @IBOutlet weak var oldNumberTextConstant: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewConstant: NSLayoutConstraint!
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var mobileNumber: String = ""
    
    var hud: MBProgressHUD?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""

    
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
        
        if SessionManager.mobileNumber().isEmpty {
            oldNumberTextField.hidden = true
            oldNumberLabel.hidden = true
            oldNumberConstant.constant = 0
            oldNumberTextConstant.constant = 0
            mainViewConstant.constant = mainViewConstant.constant - 50
        }
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        
        var changeMobileLocalizeString = StringHelper.localizedStringWithKey("CHANGEMOBILE_LOCALIZE_KEY")
        var oldNumberLocalizeString = StringHelper.localizedStringWithKey("OLDNUMBER_LOCALIZE_KEY")
        var newNumberLocalizeString = StringHelper.localizedStringWithKey("NEWNUMBER_LOCALIZE_KEY")
        var submitLocalizeString = StringHelper.localizedStringWithKey("SUBMIT_LOCALIZE_KEY")
        
        submitButton.setTitle(submitLocalizeString, forState: UIControlState.Normal)
        
        changeMobileLabel.text = changeMobileLocalizeString
        oldNumberLabel.text = oldNumberLocalizeString
        newNumberLabel.text = newNumberLocalizeString
        
        if SessionManager.mobileNumber().isEmpty {
            newNumberLabel.text = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
            submitButton.setTitle(StringHelper.localizedStringWithKey("SEND_CODE_LOCALIZED_KEY"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topMarginConstraint.constant = screenHeight! / 10
        } else if IphoneType.isIphone5() {
            topMarginConstraint.constant = screenHeight! / 5
        }
    }
    
    func tapMainViewAction() {
        if IphoneType.isIphone4() {
            if topMarginConstraint.constant == screenHeight! / 10 {
                tapMainAction()
            } else {
                buttonAction(closeButton)
            }
        } else if(IphoneType.isIphone5() ) {
            if topMarginConstraint.constant == screenHeight! / 5 {
                tapMainAction()
            } else {
                buttonAction(closeButton)
            }
        } else {
            buttonAction(closeButton)
        }
    }
    
    func tapMainAction() {
        oldNumberTextField.resignFirstResponder()
        newNumberTextField.resignFirstResponder()
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.closeChangeNumbderViewController()
        } else if sender as! UIButton == submitButton {
            oldNumberTextField.resignFirstResponder()
            newNumberTextField.resignFirstResponder()
            
            if SessionManager.mobileNumber().isEmpty {
                if newNumberTextField.text.isEmpty{
                    var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                    showAlert(title: errorLocalizeString, message: completeLocalizeString)
                } else {
                    fireUpdateProfile(APIAtlas.updateMobileNumber, params: NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
                        "newContactNumber": newNumberTextField.text]))
                }
            } else {
                if oldNumberTextField.text.isEmpty ||  newNumberTextField.text.isEmpty{
                    var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                    showAlert(title: errorLocalizeString, message: completeLocalizeString)
                } else if oldNumberTextField.text != mobileNumber {
                    var incorrectLocalizeString = StringHelper.localizedStringWithKey("INCORRECTMOBILE_LOCALIZE_KEY")
                    showAlert(title: errorLocalizeString, message: incorrectLocalizeString)
                } else {
                    fireUpdateProfile(APIAtlas.updateMobileNumber, params: NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
                        "oldContactNumber": oldNumberTextField.text,
                        "newContactNumber": newNumberTextField.text]))
                }
            }
            
        }
    }

    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var okLocalizeString = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let defaultAction = UIAlertAction(title: okLocalizeString, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
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

            manager.POST(url, parameters: params, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken(url, params: params)
                } else {
                    if responseObject["isSuccessful"] as! Bool {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.delegate?.submitChangeNumberViewController()
                        self.dismissLoader()
                    } else {
                        self.showAlert(title: self.errorLocalizeString, message: responseObject["message"] as! String)
                        self.dismissLoader()
                    }
                }
                println(responseObject)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    self.showAlert(title: self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                    self.dismissLoader()
                    println(error)
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
