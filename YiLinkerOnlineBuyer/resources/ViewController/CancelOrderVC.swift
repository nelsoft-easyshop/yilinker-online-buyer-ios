//
//  CancelOrderVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class CancelOrderVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClose(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onNo(sender: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onYes(sender: UIButton) {
        //presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CancelOrderConfirmedViewController") as! CancelOrderConfirmedVC
        vc.transitioningDelegate = self.transitioningDelegate
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(vc, animated: true, completion: nil)
        
    }

}
