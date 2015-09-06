//
//  DisputeViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DisputeViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var disputeTitle: UITextField!
    @IBOutlet weak var transactionNumber: UITextField!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var titleView: UIView!
    weak var delegate: ResolutionCenterViewController?
    
    var currentTextFieldTag: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRoundedCorners()

        // text field padding
        addPadding(self.disputeTitle)
        addPadding(self.transactionNumber)
        
        //setUpTextFields()
    }
    
    func setupRoundedCorners() {
        self.disputeTitle.layer.cornerRadius = 5
        self.transactionNumber.layer.cornerRadius = 5
        self.remarks.layer.cornerRadius = 5
        self.submitButton.layer.cornerRadius = 5
        self.modalView.layer.cornerRadius = 5
        self.titleView.layer.cornerRadius = 5
    }
    
    func addPadding(aTextField: UITextField!) {
        aTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        aTextField.leftViewMode = .Always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTextFields() {
        self.disputeTitle.delegate = self
        self.disputeTitle.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.transactionNumber.delegate = self
        self.transactionNumber.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.remarks.delegate = self
        //self.remarks.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
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
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.adjustTextFieldYInsetWithInset(1600)
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.adjustTextFieldYInsetWithInset(60)
        return true
        /*
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
        */
    }

    
    func showCloseButton() {
//        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
//            UIView.animateWithDuration(0.3, delay: 0.0, options: nil, animations: {
//                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
//                parentViewController.closeButton.alpha = 1
//                }, completion: {(value: Bool) in
//                    
//            })
//        }
    }
    
    func adjustTextFieldYInsetWithInset(inset: CGFloat) {
//        if self.parentViewController!.isKindOfClass(LoginAndRegisterContentViewController) {
//            UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
//                let parentViewController: LoginAndRegisterContentViewController = self.parentViewController as! LoginAndRegisterContentViewController
//                parentViewController.verticalSpaceConstraint.constant = inset
//                self.parentViewController!.view.layoutIfNeeded()
//                }, completion: {(value: Bool) in
//                    
//            })
//        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dissmissDisputeViewController(self, type: "none")
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dissmissDisputeViewController(self, type: "none")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
