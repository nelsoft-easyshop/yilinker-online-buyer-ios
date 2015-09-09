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

    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var mobileNumber: String = ""
    
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
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            topMarginConstraint.constant = screenHeight! / 10
        }
    }
    
    func tapMainViewAction() {
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            if topMarginConstraint.constant == screenHeight! / 10 {
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
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.closeChangePasswordViewController()
        } else if sender as! UIButton == submitButton {
            if oldPasswordTextField.text.isEmpty ||  newPasswordTextField.text.isEmpty || confirmPasswordTextField.text.isEmpty {
                showAlert(title: "Error", message: "Complete necessary fields!")
            } else if newPasswordTextField.text != confirmPasswordTextField.text {
                showAlert(title: "Error", message: "Password does not match!")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
                self.delegate?.submitChangePasswordViewController()
            }
        }
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
