//
//  VerifyMobileNumberStatusViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol VerifyMobileNumberStatusViewControllerDelegate {
    func closeVerifyMobileNumberStatusViewController()
    func continueVerifyMobileNumberAction(isSuccessful: Bool)
    func requestNewVerificationCodeAction()
}

class VerifyMobileNumberStatusViewController: UIViewController {
    
    var delegate: VerifyMobileNumberStatusViewControllerDelegate?

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    var isSuccessful: Bool = false
    
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
        continueButton.layer.cornerRadius = 5
        requestButton.layer.cornerRadius = 5
        iconView.layer.cornerRadius = iconView.frame.height / 2
        
        if isSuccessful {
            iconView.backgroundColor = Constants.Colors.successfulVerification
            iconImageView.image = UIImage(named: "checkAddress")
            continueButton.hidden = false
            requestButton.hidden = true
            titleLabel.text = StringHelper.localizedStringWithKey("CONGRATULATIONS_LOCALIZED_KEY")
            messageLabel.text = StringHelper.localizedStringWithKey("SUCCESS_VERIFIED_LOCALIZED_KEY")
        } else {
            
            SessionManager.setMobileNumber("")
            setNewMobileNumber("")
            
            iconView.backgroundColor = Constants.Colors.errorVerification
            iconImageView.image = UIImage(named: "oops")
            continueButton.hidden = true
            requestButton.hidden = false
            titleLabel.text = StringHelper.localizedStringWithKey("OOOOPS_LOCALIZE_KEY")
            messageLabel.text = StringHelper.localizedStringWithKey("FAILED_VERIFIED_LOCALIZED_KEY")
        }
    }

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeVerifyMobileNumberStatusViewController()
        } else if sender as! UIButton == continueButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.continueVerifyMobileNumberAction(isSuccessful)
        }else if sender as! UIButton == requestButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.requestNewVerificationCodeAction()
        }
    }

    func setNewMobileNumber(newMobileNumber: String) {
        NSUserDefaults.standardUserDefaults().setObject(newMobileNumber, forKey: "newMobileNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
