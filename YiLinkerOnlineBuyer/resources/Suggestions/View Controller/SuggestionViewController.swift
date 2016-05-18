//
//  SuggestionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 3/16/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct SuggestionStrings {
    static let header = StringHelper.localizedStringWithKey("SUGGESTION_HEADLINE")
    static let subHeader = StringHelper.localizedStringWithKey("SUGGESTION_SUB_HEADLINE")
    static let title = StringHelper.localizedStringWithKey("SUGGESTION_TITLE")
    static let titlePlaceholder = StringHelper.localizedStringWithKey("SUGGESTION_TITLE_LABEL")
    static let descriptionPlaceholder = StringHelper.localizedStringWithKey("SUGGESTION_DESCRIPTION")
    static let send = StringHelper.localizedStringWithKey("SUGGESTION_SEND")
    static let titleRequiredError = StringHelper.localizedStringWithKey("SUGGESTION_TITLE_REQUIRED")
    static let descriptionRequiredError = StringHelper.localizedStringWithKey("SUGGESTION_DESC_REQUIRED")
}

struct SuggestionNotifications {
    static let validationErrorNotification = "validationErrorNotification"
    static let saveFeedbackNotification = "saveFeedbackNotification"
    static let refreshTokenErrorNotification = "refreshTokenErrorNotification"
    static let statusChangedNotification = "statusChangedNotification"
}

class SuggestionViewController: UIViewController {

    private let suggestionViewModel = SuggestionViewModel()
    
    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var subLineLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var notificationCenter = NSNotificationCenter.defaultCenter()
    
    var originalTopMarginConstant: CGFloat =  0
    var toYconstraint: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.addBackButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerNotificationObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNotificationObserver() { 
        //Register notification observer
        notificationCenter.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("onValidationErrorNotification:"), name: SuggestionNotifications.validationErrorNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("onSaveFeedbackNotification:"), name: SuggestionNotifications.saveFeedbackNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("onRefreshTokenErrorNotification:"), name: SuggestionNotifications.refreshTokenErrorNotification, object: nil)
        notificationCenter.addObserver(self, selector: Selector("onStatusChangedNotification:"), name: SuggestionNotifications.statusChangedNotification, object: nil)
    }
    
    func unregisterNotificationObserver() {
        //unegister notification observer
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: SuggestionNotifications.validationErrorNotification, object: nil)
        notificationCenter.removeObserver(self, name: SuggestionNotifications.saveFeedbackNotification, object: nil)
        notificationCenter.removeObserver(self, name: SuggestionNotifications.refreshTokenErrorNotification, object: nil)
    }
    
    func initializeViews() {
        //Avoid overlapping of tab bar and navigation bar to the mainview
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.title = SuggestionStrings.title
        self.sendButton.layer.cornerRadius = 5
        self.descriptionTextView.layer.cornerRadius = 5
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.titleTextField.layer.cornerRadius = 5
        self.titleTextField.layer.borderWidth = 1
        self.titleTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        self.headLineLabel.text = SuggestionStrings.header
        self.subLineLabel.text = SuggestionStrings.subHeader
        self.descriptionTextView.text = SuggestionStrings.descriptionPlaceholder
        self.titleTextField.text = SuggestionStrings.titlePlaceholder
        self.titleTextField.required()
        self.descriptionTextView.required()
        self.sendButton.setTitle(SuggestionStrings.send, forState: .Normal)
        
        self.titleTextField.delegate = self
        self.descriptionTextView.delegate = self
        
        if IphoneType.isIphone4() {
            self.topMarginConstraint.constant = 12
            self.toYconstraint = -120
        } else if IphoneType.isIphone5() {
            self.toYconstraint = -80
        } else if IphoneType.isIphone6() {
            self.toYconstraint = 20
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        self.view.addGestureRecognizer(tap)
        
        self.originalTopMarginConstant = self.topMarginConstraint.constant
    }
    
    //Add cutomize back button to the navigation bar
    func addBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func sendAction(sender: UIButton) {
        self.closeKeyboard()
        
        if self.titleTextField.attributedText?.string == "\(SuggestionStrings.titlePlaceholder)*" {
            self.suggestionViewModel.title = ""
        } else {
            self.suggestionViewModel.title = self.titleTextField.text
        }
        
        if self.descriptionTextView.attributedText.string == "\(SuggestionStrings.descriptionPlaceholder)*" {
            self.suggestionViewModel.description = ""
        } else {
            self.suggestionViewModel.description = self.descriptionTextView.text
        }
        
        self.suggestionViewModel.handleSavePressed()
    }
    
    func setStatusOngoing(isOngoing: Bool) {
        
        self.sendButton.enabled = !isOngoing
        self.titleTextField.enabled = !isOngoing
        self.descriptionTextView.editable = !isOngoing
        
        if isOngoing {
            self.sendButton.setTitle("", forState: .Normal)
            self.sendButton.alpha = 0.5
            self.activityIndicator.startAnimating()
        } else {
            self.sendButton.setTitle(SuggestionStrings.send, forState: .Normal)
            self.sendButton.alpha = 1
            self.activityIndicator.stopAnimating()
            self.titleTextField.text = SuggestionStrings.titlePlaceholder
            self.descriptionTextView.text = SuggestionStrings.descriptionPlaceholder
            self.titleTextField.required()
            self.descriptionTextView.required()
        }
    }
    
    // MARK: Notification Handler
    
    // Keyboard notification function
    /* Update frame of whole view when keyboard is showing by subtracting keyboard height to
    * original Y origin of view and adding the tab bar height */
    func keyboardWillShow (notification: NSNotification){
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                self.topMarginConstraint.constant = self.toYconstraint
                UIView.animateWithDuration(0.35, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    /* Update frame of whole view when keyboard is hiding by setting its original frame*/
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardHeight = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue().size.height {
                self.topMarginConstraint.constant = self.originalTopMarginConstant
                UIView.animateWithDuration(0.35, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func onValidationErrorNotification(notification: NSNotification) {
        if let errorMessage = notification.object as? String {
            Toast.displayToastWithMessage(errorMessage, duration: 1.5, view: self.navigationController!.view)
        }
    }
    
    func onSaveFeedbackNotification(notification: NSNotification) {
        if let responseObject = notification.object as? NSDictionary {
            if let message = responseObject["message"] as? String {
                Toast.displayToastWithMessage(message, duration: 1.5, view: self.navigationController!.view)
            }
        }
    }
    
    func onRefreshTokenErrorNotification(notification: NSNotification) {
        //Show UIAlert and force the user to logout
        UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
            SessionManager.logoutWithTarget(self)
        })
    }
    
    func onStatusChangedNotification(notification: NSNotification) {
        if let status = notification.object as? Bool {
            self.setStatusOngoing(status)
        }
    }
}

extension SuggestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.attributedText.string == "\(SuggestionStrings.descriptionPlaceholder)*" {
            textView.text = ""
            textView.textColor = UIColor.darkGrayColor()
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text == "" {
            textView.text = SuggestionStrings.descriptionPlaceholder
            textView.textColor = UIColor.lightGrayColor()
            textView.required()
        }
        
        textView.resignFirstResponder()
    }
}

extension SuggestionViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.attributedText?.string == "\(SuggestionStrings.titlePlaceholder)*" {
            textField.text = ""
            textField.textColor = UIColor.darkGrayColor()
        }
        
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = SuggestionStrings.titlePlaceholder
            textField.textColor = UIColor.lightGrayColor()
            textField.required()
        }
        
        textField.resignFirstResponder()
    }
}