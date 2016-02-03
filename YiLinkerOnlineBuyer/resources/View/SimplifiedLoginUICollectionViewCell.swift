//
//  SimplifiedLoginTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SimplifiedLoginUICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var byMobileButton: UIButton!
    @IBOutlet weak var byEmailButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    @IBOutlet weak var emailMobileTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var areaCodeView: UIView!
    @IBOutlet weak var areaCodeLabel: UILabel!
    @IBOutlet weak var areaCodeConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var downImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initializeViews()
    }
    
    func initializeViews() {
        
        self.downImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
        self.signInButton.layer.cornerRadius = 3
        self.facebookButton.layer.cornerRadius = 3
        
        //Set inset of textfield
        self.emailMobileTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        //Set border attributes
        self.emailMobileTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.passwordTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.areaCodeView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        
        self.emailMobileTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
        self.areaCodeView.layer.borderWidth = 1
        
        self.buttonAction(self.byMobileButton)
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == self.byMobileButton {
            self.byMobileButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
            self.byEmailButton.setTitleColor(Constants.Colors.grayText, forState: UIControlState.Normal)
            self.emailMobileTextField.keyboardType = UIKeyboardType.PhonePad
            self.areaCodeConstraint.constant = 69
            UIView.animateWithDuration(0.25) {
                self.layoutIfNeeded()
            }
        } else if sender as! UIButton == self.byEmailButton {
            self.byEmailButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
            self.byMobileButton.setTitleColor(Constants.Colors.grayText, forState: UIControlState.Normal)
            self.emailMobileTextField.keyboardType = UIKeyboardType.EmailAddress
            self.areaCodeConstraint.constant = 0
            UIView.animateWithDuration(0.25) {
                self.layoutIfNeeded()
            }
        }
    }
    
    
    
}
