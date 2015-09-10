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
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var mobileNumber: String = ""
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
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
            
            if oldNumberTextField.text.isEmpty ||  newNumberTextField.text.isEmpty{
                showAlert(title: "Error", message: "Complete necessary fields!")
            } else if oldNumberTextField.text != mobileNumber {
                showAlert(title: "Error", message: "Incorrect old mobile number!")
            } else {
                fireUpdateProfile(APIAtlas.updateMobileNumber, params: NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
                    "oldContactNumber": oldNumberTextField.text,
                    "newContactNumber": newNumberTextField.text]))
            }
        }
    }

    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
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
                        self.showAlert(title: "Error", message: responseObject["message"] as! String)
                        self.dismissLoader()
                    }
                }
                println(responseObject)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    self.showAlert(title: "Error", message: "Something went wrong. . .")
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
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissLoader()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(title: "Something went wrong", message: "")
                
        })
    }
    



}
