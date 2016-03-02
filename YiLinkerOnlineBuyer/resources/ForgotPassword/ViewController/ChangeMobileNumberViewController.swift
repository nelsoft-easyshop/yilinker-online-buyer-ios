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
    
    var isFromCheckout: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeLocalizedString()
        
        oldNumberTextField.text = mobileNumber
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
        let viewType = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
        self.tapView.addGestureRecognizer(viewType)
        
        let view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
        
        if !SessionManager.isMobileVerified() {
            if isFromCheckout {
                oldNumberTextField.hidden = true
                oldNumberLabel.hidden = true
                oldNumberConstant.constant = 0
                oldNumberTextConstant.constant = 0
                mainViewConstant.constant = mainViewConstant.constant - 50

                newNumberTextField.text = mobileNumber
            }
        }
    }
    
    func initializeLocalizedString() {
        
        var changeMobileLocalizeString = StringHelper.localizedStringWithKey("CHANGEMOBILE_LOCALIZE_KEY")
        var oldNumberLocalizeString = StringHelper.localizedStringWithKey("OLDNUMBER_LOCALIZE_KEY")
        var newNumberLocalizeString = StringHelper.localizedStringWithKey("NEWNUMBER_LOCALIZE_KEY")
        var submitLocalizeString = StringHelper.localizedStringWithKey("SUBMIT_LOCALIZE_KEY")
        
        submitButton.setTitle(submitLocalizeString, forState: UIControlState.Normal)
        
        changeMobileLabel.text = changeMobileLocalizeString
        oldNumberLabel.text = oldNumberLocalizeString
        newNumberLabel.text = newNumberLocalizeString
        
        if !SessionManager.isMobileVerified() {
            titleLabel.text = StringHelper.localizedStringWithKey("YOUR_MOBILE_LOCALIZE_KEY")
            newNumberLabel.text = StringHelper.localizedStringWithKey("PLEASE_ENTER_NUMBER_LOCALIZE_KEY")
            newNumberTextField.placeholder = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
            submitButton.setTitle(StringHelper.localizedStringWithKey("SUBMIT_CAPS_LOCALIZE_KEY"), forState: UIControlState.Normal)
        } else {
            titleLabel.text = StringHelper.localizedStringWithKey("CHANGEMOBILE_LOCALIZE_KEY")
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
            
            if !SessionManager.isMobileVerified(){
                if newNumberTextField.text.isEmpty{
                    var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: completeLocalizeString)
                } else {
                    if SessionManager.mobileNumber().isEmpty {
                        setNewMobileNumber(newNumberTextField.text)
                    } else {
                        if SessionManager.mobileNumber() == newNumberTextField.text {
                            SessionManager.setMobileNumber(SessionManager.mobileNumber())
                            setNewMobileNumber(SessionManager.mobileNumber())
                        } else {
                            setNewMobileNumber(newNumberTextField.text)
                        }
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.submitChangeNumberViewController()
                }
            } else {
                if oldNumberTextField.text.isEmpty ||  newNumberTextField.text.isEmpty{
                    var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: completeLocalizeString)
                } else if oldNumberTextField.text != mobileNumber {
                    var incorrectLocalizeString = StringHelper.localizedStringWithKey("INCORRECTMOBILE_LOCALIZE_KEY")
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: incorrectLocalizeString)
                } else {
                    SessionManager.setMobileNumber(oldNumberTextField.text)
                    setNewMobileNumber(newNumberTextField.text)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.submitChangeNumberViewController()
                }
            }
        }
    }
    
    func setNewMobileNumber(newMobileNumber: String) {
        NSUserDefaults.standardUserDefaults().setObject(newMobileNumber, forKey: "newMobileNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
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
}
