//
//  TransactionCancelViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/11/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionCancelViewController: UIViewController {

    @IBOutlet weak var remarksTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remarksTextView.layer.cornerRadius = 5.0
        remarksTextView.clipsToBounds = true
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
