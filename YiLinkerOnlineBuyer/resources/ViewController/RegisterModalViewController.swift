//
//  RegisterModalViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol RegisterModalViewControllerDelegate {
    func registerModalViewController(didExit view: RegisterModalViewController)
    func registerModalViewController(didSave view: RegisterModalViewController, password: String)
}

class RegisterModalViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate: RegisterModalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissView")
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(sender: AnyObject) {
        if self.passwordTextField.text == self.confirmPasswordTextField.text {
            self.delegate?.registerModalViewController(didSave: self, password: self.passwordTextField.text)
            self.dismissView()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mismatched password.", title: "Invalid Credential")
        }
    }
    
    func dismissView() {
        self.delegate?.registerModalViewController(didExit: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissView()
    }
}
