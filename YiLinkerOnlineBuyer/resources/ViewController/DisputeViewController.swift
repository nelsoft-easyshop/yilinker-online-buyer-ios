//
//  DisputeViewController.swift
//  Resolution Center
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
    @IBOutlet weak var caseId: UILabel!
    @IBOutlet weak var verticalSpaceInset: NSLayoutConstraint!
    
    var currentTextFieldTag: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRoundedCorners()
        defaultModalPosition()
        setUpTextFields()
    }
    
    func setupRoundedCorners() {
        self.disputeTitle.layer.cornerRadius = 5
        addPadding(self.disputeTitle)
        self.transactionNumber.layer.cornerRadius = 5
        addPadding(self.transactionNumber)
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
    
    func defaultModalPosition() {
        let defaultIphone4Inset: CGFloat = 16
        let defaultIphone5Inset: CGFloat = 32
        let defaultIphone6Inset: CGFloat = 64
        let defaultIphone6PlusInset: CGFloat = 64
        
        if IphoneType.isIphone4() {
            self.adjustVerticalInset( defaultIphone4Inset )
        } else if IphoneType.isIphone5() {
            self.adjustVerticalInset( defaultIphone5Inset )
        } else if IphoneType.isIphone6() {
            self.adjustVerticalInset( defaultIphone6Inset )
        } else if IphoneType.isIphone6Plus() {
            self.adjustVerticalInset( defaultIphone6PlusInset )
        }
    }
    
    func setUpTextFields() {
        self.disputeTitle.tag = 1
        self.disputeTitle.delegate = self
        self.disputeTitle.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.transactionNumber.tag = 2
        self.transactionNumber.delegate = self
        self.transactionNumber.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        self.remarks.tag = 3
        self.remarks.delegate = self
        self.remarks.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
    }
    
    func done() {
        self.view.endEditing(true)
        self.defaultModalPosition()
    }
    
    func previous() {
        let previousTag: Int = self.currentTextFieldTag - 1
        
        if let textField: UITextField = self.view.viewWithTag(previousTag) as? UITextField {
            textField.becomeFirstResponder()
        }
    }
    
    
    func next() {
        let nextTag: Int = self.currentTextFieldTag + 1
        
        if let textField: UITextField = self.view.viewWithTag(nextTag) as? UITextField {
            textField.becomeFirstResponder()
            self.currentTextFieldTag = nextTag
        } else if let textView: UITextView = self.view.viewWithTag(nextTag) as? UITextView {
            textView.becomeFirstResponder()
            self.currentTextFieldTag = nextTag
        } else {
            self.done()
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.currentTextFieldTag = textView.tag
        
        if IphoneType.isIphone4() {
            self.adjustVerticalInset(-165)
        } else if IphoneType.isIphone5() {
            self.adjustVerticalInset(-65)
        } else if IphoneType.isIphone6() {
            self.adjustVerticalInset(15)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.currentTextFieldTag = textField.tag
        
        self.defaultModalPosition()
        
        // original code at LoginViewController::textFieldShouldBeginEditing
        return true
    }
    
    func adjustVerticalInset(inset: CGFloat) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
            self.verticalSpaceInset.constant = inset
            self.view.layoutIfNeeded()
            }, completion: {(value: Bool) in
                
        })
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.delegate?.dissmissDisputeViewController(self, type: "none")
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.delegate?.dissmissDisputeViewController(self, type: "none")
    }
    
}
