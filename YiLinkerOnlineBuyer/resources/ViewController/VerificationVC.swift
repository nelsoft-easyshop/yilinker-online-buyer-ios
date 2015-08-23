//
//  VerificationVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class VerificationVC: UIViewController {

    struct Verification{
        static let SUCCESS = "SUCCCESS"
        static let FAIL = "FAIL"
    }
    
    var mode : String = String()
    
    @IBAction func onTapButton(sender: UIButton) {
        if (mode == Verification.SUCCESS) {
        
        } else if (mode == Verification.FAIL) {
        
        }
        
    }
    
    @IBAction func onClose(sender: UIButton) {
        if (mode == Verification.SUCCESS) {
            
        } else if (mode == Verification.FAIL) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
