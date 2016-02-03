//
//  SimplifiedRegistrationUICollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SimplifiedRegistrationUICollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var referralCodeTextField: UITextField!
    @IBOutlet weak var activationCodeTextField: UITextField!
    
    @IBOutlet weak var areaCodeView: UIView!
    @IBOutlet weak var areaCodeLabel: UILabel!

    @IBOutlet weak var sendActivationCodeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var downImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.initializeViews()
    }
    
    func initializeViews() {
        self.registerButton.layer.cornerRadius = 3
        
        self.downImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        
        //Set inset of textfield
        self.mobileNumberTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.confirmPasswordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.referralCodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        self.activationCodeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        //Set border attributes
        self.mobileNumberTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.passwordTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.confirmPasswordTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.referralCodeTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.activationCodeTextField.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.areaCodeView.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        
        
        self.mobileNumberTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderWidth = 1
        self.confirmPasswordTextField.layer.borderWidth = 1
        self.referralCodeTextField.layer.borderWidth = 1
        self.activationCodeTextField.layer.borderWidth = 1
        self.areaCodeView.layer.borderWidth = 1
        
        //Set placeholder
    }

}
