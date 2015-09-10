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
    func continueVerifyMobileNumberAction()
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
            titleLabel.text = "Congratulations!"
            messageLabel.text = "You have successfully verified your account."
        } else {
            iconView.backgroundColor = Constants.Colors.errorVerification
            iconImageView.image = UIImage(named: "oops")
            continueButton.hidden = true
            requestButton.hidden = false
            titleLabel.text = "Ooooops!!"
            messageLabel.text = "You have either entered an incorrect code or it has already expired."
        }
    }

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeVerifyMobileNumberStatusViewController()
        } else if sender as! UIButton == continueButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.continueVerifyMobileNumberAction()
        }else if sender as! UIButton == requestButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.requestNewVerificationCodeAction()
        }
    }

}
