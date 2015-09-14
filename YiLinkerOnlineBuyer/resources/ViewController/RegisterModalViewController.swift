//
//  RegisterModalViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol RegisterModalViewControllerDelegate {
    func registerModalViewController(didExit view: RegisterModalViewController, isShowRegister: Bool)
}

class RegisterModalViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    
    var delegate: RegisterModalViewControllerDelegate?
    var isShowRegister: Bool = false
    
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
