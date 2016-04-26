//
//  LoginRegisterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LoginRegisterTableViewCellDelegate {
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, textFieldShouldReturn textField: UITextField)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapFBLogin facebookButton: FBSDKLoginButton)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapForgotPassword forgotPasswordButton: UIButton)
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapSignin signInButton: UIButton)
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, textFieldShouldReturn textField: UITextField)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapLanguagePreference languagePreferenceView: UIView)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapAreaCode areaCodeView: UIView)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapSendActivationCode sendActivationCodeButton: UIButton)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapRegister registerButton: UIButton)
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTimerEnded registerButton: UIButton)
    
    func loginRegisterTableViewCell(loginRegisterTableViewCell: LoginRegisterTableViewCell, didTapSignIn signInButton: UIButton)
    func loginRegisterTableViewCell(loginRegisterTableViewCell: LoginRegisterTableViewCell, didTapRegister registerButton: UIButton)
}

class LoginRegisterTableViewCell: UITableViewCell {
    
    var delegate: LoginRegisterTableViewCellDelegate?

    //Cell Identifier
    let reuseIdentifierLogin: String = "SimplifiedLoginUICollectionViewCell"
    let reuseIdentifierRegistration: String = "SimplifiedRegistrationUICollectionViewCell"
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var screenWidth: CGFloat = 0
    
    var tempCtr: Int = 0
    var oldScrollValue: CGFloat = 0
    
    var referralCode: String = ""
    var isLogin: Bool = true
    
    var selectedCountry = CountryModel()
    var selectedLanguage = LanguageModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initializeViews()
        self.registerNibs()
        self.activateButton(self.signInButton)
        self.deActivateButton(self.registerButton)
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.checkView()
        }
        
    }
    
    func initializeViews() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.screenWidth = screenSize.width
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.signInButton.setTitle(LoginStrings.login.uppercaseString, forState: .Normal)
        self.registerButton.setTitle(RegisterStrings.register.uppercaseString, forState: .Normal)

    }
    
    func checkView() {
        if self.isLogin {
            self.delegate?.loginRegisterTableViewCell(self, didTapSignIn: self.registerButton)
            self.activateButton(self.signInButton)
            self.deActivateButton(self.registerButton)
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        } else {
            self.delegate?.loginRegisterTableViewCell(self, didTapRegister: self.signInButton)
            self.deActivateButton(self.signInButton)
            self.activateButton(self.registerButton)
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        }
    }
    
    func registerNibs() {
        var cellNibLogin = UINib(nibName: reuseIdentifierLogin, bundle: nil)
        self.collectionView?.registerNib(cellNibLogin, forCellWithReuseIdentifier: reuseIdentifierLogin)
        
        var cellNibRegistration = UINib(nibName: reuseIdentifierRegistration, bundle: nil)
        self.collectionView?.registerNib(cellNibRegistration, forCellWithReuseIdentifier: reuseIdentifierRegistration)
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.signInButton {
            self.delegate?.loginRegisterTableViewCell(self, didTapSignIn: sender)
            self.activateButton(self.signInButton)
            self.deActivateButton(self.registerButton)
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        } else if sender == self.registerButton {
            self.delegate?.loginRegisterTableViewCell(self, didTapRegister: sender)
            self.deActivateButton(self.signInButton)
            self.activateButton(self.registerButton)
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        }
    }
    //MARK: -
    //MARK: - Activate Button
    func activateButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.backgroundColor = Constants.Colors.appTheme
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    //MARK: -
    //MARK: - De Activate Button
    func deActivateButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.backgroundColor = .clearColor()
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.layer.borderWidth = 1
        button.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
    }
}

//MARK: - Data Source And Delegate
//MARK: -  Collection View Data Source And Delegate
extension LoginRegisterTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    //MARK: -  UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell: SimplifiedLoginUICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierLogin, forIndexPath: indexPath) as! SimplifiedLoginUICollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell: SimplifiedRegistrationUICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierRegistration, forIndexPath: indexPath) as! SimplifiedRegistrationUICollectionViewCell
            cell.referralCodeTextField.text = self.referralCode
            cell.languagePreferenceLabel.text = "\(self.selectedLanguage.name) (\(self.selectedLanguage.code.uppercaseString))"
            cell.areaCodeLabel.text = "+\(self.selectedCountry.areaCode)"
            cell.areaCodeImageView.sd_setImageWithURL(NSURL(string: self.selectedCountry.flag), placeholderImage: UIImage(named: "dummy-placeholder"))
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.screenWidth, height:390)
    }

    //MARK: -  UICollectionViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tempCtr == 0 {
            let contentOffset = scrollView.contentOffset.x
            
            if self.oldScrollValue > contentOffset {
                self.delegate?.loginRegisterTableViewCell(self, didTapSignIn: self.signInButton)
                self.activateButton(self.signInButton)
                self.deActivateButton(self.registerButton)
            } else {
                self.delegate?.loginRegisterTableViewCell(self, didTapRegister: self.registerButton)
                self.deActivateButton(self.signInButton)
                self.activateButton(self.registerButton)
            }
            
            self.oldScrollValue = contentOffset
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.tempCtr = 0
    }
}

//MARK: -
//MARK: -  Simplified Login UI CollectionViewCell Delegate
extension LoginRegisterTableViewCell: SimplifiedLoginUICollectionViewCellDelegate {
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, textFieldShouldReturn textField: UITextField) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, textFieldShouldReturn: textField)
    }
    
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapFBLogin facebookButton: FBSDKLoginButton) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, didTapFBLogin: facebookButton)
    }
    
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapForgotPassword forgotPasswordButton: UIButton) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, didTapForgotPassword: forgotPasswordButton)
    }
    
    func simplifiedLoginCell(simplifiedLoginCell: SimplifiedLoginUICollectionViewCell, didTapSignin signInButton: UIButton) {
        self.delegate?.simplifiedLoginCell(simplifiedLoginCell, didTapSignin: signInButton)
    }
}

//MARK: -  SimplifiedRegistrationUICollectionViewCellDelegate
extension LoginRegisterTableViewCell: SimplifiedRegistrationUICollectionViewCellDelegate {
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, textFieldShouldReturn textField: UITextField) {
        self.delegate?.simplifiedRegistrationCell(simplifiedRegistrationCell, textFieldShouldReturn: textField)
    }
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapLanguagePreference languagePreferenceView: UIView) {
        self.delegate?.simplifiedRegistrationCell(simplifiedRegistrationCell, didTapLanguagePreference: languagePreferenceView)
    }
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapAreaCode areaCodeView: UIView) {
        self.delegate?.simplifiedRegistrationCell(simplifiedRegistrationCell, didTapAreaCode: areaCodeView)
    }
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapSendActivationCode sendActivationCodeButton: UIButton) {
        self.delegate?.simplifiedRegistrationCell(simplifiedRegistrationCell, didTapSendActivationCode: sendActivationCodeButton)
    }
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTapRegister registerButton: UIButton) {
        self.delegate?.simplifiedRegistrationCell(simplifiedRegistrationCell, didTapRegister: registerButton)
    }
    
    func simplifiedRegistrationCell(simplifiedRegistrationCell: SimplifiedRegistrationUICollectionViewCell, didTimerEnded sendActivationCodeButton: UIButton) {
        self.delegate?.simplifiedRegistrationCell(simplifiedRegistrationCell, didTimerEnded: sendActivationCodeButton)
    }
}

