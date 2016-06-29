//
//  RegisterModalViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct RegisterModalStrings {
    static let yes: String = StringHelper.localizedStringWithKey("YES_LOCALIZE_KEY")
    static let no: String = StringHelper.localizedStringWithKey("NO_LOCALIZE_KEY")
    static let createMessage: String = StringHelper.localizedStringWithKey("CREATE_MESSAGE_PURCHASE_LOCALIZE_KEY")
    static let doYouWant: String = StringHelper.localizedStringWithKey("CREATE_ACCOUT_LOCALIZE_KEY")
}

protocol RegisterModalViewControllerDelegate {
    func registerModalViewController(didExit view: RegisterModalViewController, isShowRegister: Bool)
}

class RegisterModalViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var doYouWantLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    
    var delegate: RegisterModalViewControllerDelegate?
    var isShowRegister: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissView")
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(gestureRecognizer)
        
        self.createButton.setTitle(RegisterModalStrings.yes, forState: UIControlState.Normal)
        self.noButton.setTitle(RegisterModalStrings.no, forState: UIControlState.Normal)
        
        self.doYouWantLabel.text = RegisterModalStrings.doYouWant
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yes(sender: AnyObject) {
        self.isShowRegister = true
        self.dismissView()
    }
    
    @IBAction func no(sender: AnyObject) {
        self.dismissView()
    }
    
    
    func dismissView() {
        self.delegate?.registerModalViewController(didExit: self, isShowRegister: self.isShowRegister)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func close(sender: AnyObject) {
        self.dismissView()
    }
}
