//
//  VerifyNumberViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 2/2/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol VerifyNumberViewControllerDelegate {
    func verifyNumberViewController(verifyNumberViewController: VerifyNumberViewController, didStartEditing textField: UITextField)
    func verifyNumberViewController(verifyNumberViewController: VerifyNumberViewController, didTapSend textField: UITextField)
    func verifyNumberViewController(verifyNumberViewController: VerifyNumberViewController, changeState modalState: ModalState)
}

class VerifyNumberViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var verifyTitleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpacingConstant: NSLayoutConstraint!
    @IBOutlet weak var timeLeftVerticalSpacingConstant: NSLayoutConstraint!
    @IBOutlet weak var wrongCodeLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timeInterval: Int = 15
    
    var delegate: VerifyNumberViewControllerDelegate?
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.submitButton.layer.cornerRadius = 5
        self.codeTextField.delegate = self
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "moveScreenToDefaultPosition")
        //self.view.addGestureRecognizer(tapGesture)
        
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
        self.activityIndicator.layer.zPosition = 100
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        
        if IphoneType.isIphone6() {
            self.verticalSpacingConstant.constant = 170
        }  else if IphoneType.isIphone6Plus() {
            self.verticalSpacingConstant.constant = 200
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Update Time
    func updateTime() {
        self.timeInterval--
        let (hour, min, seconds): (Int, Int, Int) = self.secondsToHoursMinutesSeconds(self.timeInterval)
        if self.timeInterval < 0 {
             self.delegate?.verifyNumberViewController(self, changeState: .SessionExpired)
        } else {
            if self.timeInterval >= 10 {
                self.timerLabel.text = "Time Left  0\(min):\(seconds)"
            } else {
                self.timerLabel.text = "Time Left  0\(min):0\(seconds)"
            }
        }
        
    }
    
    //MARK: -
    //MARK: - Dismiss
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: -
    //MARK: - Close With Result
    func close() {
        self.delegate?.verifyNumberViewController(self, changeState: .DismissModal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 
    //MARK: - Show Wrong Code Label
    func showWrongCodeLabel() {
        self.timeLeftVerticalSpacingConstant.constant = 0
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: { (Bool) -> Void in
                self.wrongCodeLabel.hidden = false
        })
    }
    
    //MARK: -
    //MARK: - Text Field Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.delegate?.verifyNumberViewController(self, didStartEditing: textField)
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.delegate?.verifyNumberViewController(self, didTapSend: textField)
        return true
    }
    
    //MARK: -
    //MARK: - Start Loading
    func startLoading() {
        self.view.userInteractionEnabled = false
        self.activityIndicator.startAnimating()
    }
    
    //MARK: -
    //MARK: - Stop Loading
    func stopLoading() {
        self.view.userInteractionEnabled = true
        self.activityIndicator.stopAnimating()
    }
    
    //MARK: -
    //MARK: - Seconds To Hours Minutes Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: - 
    //MARK: - Move Screen To Default Position
    func moveScreenToDefaultPosition() {
        self.view.endEditing(true)
        if IphoneType.isIphone4() {
            self.verticalSpacingConstant.constant = 120
        } else if IphoneType.isIphone6() {
            self.verticalSpacingConstant.constant = 170
        } else if IphoneType.isIphone6Plus() {
            self.verticalSpacingConstant.constant = 200
        }
        
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - 
    //MARK: - Update UI to Session Expired
    func updateUIToSessionExpired() {
        if IphoneType.isIphone4() {
            self.verticalSpacingConstant.constant = 120
        }

        self.codeTextField.hidden = true
        self.timerLabel.hidden = true
        
        self.containerViewHeightConstraint.constant = 200
        
        self.wrongCodeLabel.text = "Session Expired"
        self.wrongCodeLabel.hidden = false
        
        self.updateSubmitButtonUIForResendCode()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.submitButton.layoutIfNeeded()
            self.containerView.layoutIfNeeded()
        })
    }
    
    //MARK: -
    //MARK: - Update Submit Button UI For Resend Code
    func updateSubmitButtonUIForResendCode() {
        self.submitButton.setTitle("RESEND CODE", forState: UIControlState.Normal)
        self.submitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.submitButton.backgroundColor = Constants.Colors.appTheme
    }
    
    //MARK: -
    //MARK: - Update Submit Button UI For SUBMIT Code
    func updateSubmitButtonUIForSubmitCode() {
        self.submitButton.setTitle("SUBMIT", forState: UIControlState.Normal)
        self.submitButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.submitButton.backgroundColor = Constants.Colors.onlineColor
    }
    
    //MARK: - 
    //MARK: - Submit
    @IBAction func submit(sender: UIButton) {
        self.delegate?.verifyNumberViewController(self, didTapSend: self.codeTextField)
    }
    
    //MARK: - 
    //MARK: - Update UI To Default
    func updateUIToDefault() {
        if IphoneType.isIphone4() {
            self.verticalSpacingConstant.constant = 120
        } else if IphoneType.isIphone6() {
            self.verticalSpacingConstant.constant = 170
        }
        
        self.codeTextField.hidden = false
        self.timerLabel.hidden = false
        
        self.containerViewHeightConstraint.constant = 240
        
        self.wrongCodeLabel.text = "Wrong Code"
        self.wrongCodeLabel.hidden = true
        
        self.updateSubmitButtonUIForSubmitCode()
        
        self.timeInterval = 10
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.submitButton.layoutIfNeeded()
            self.containerView.layoutIfNeeded()
        })
    }
}