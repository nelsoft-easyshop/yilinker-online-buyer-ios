//
//  TransactionCancelOrderSuccessViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/5/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol TransactionCancelOrderSuccessViewControllerDelegate {
    func closeCancelOrderSuccessViewController()
    func returnToDashboardAction()
}

class TransactionCancelOrderSuccessViewController: UIViewController {

    var delegate: TransactionCancelOrderSuccessViewControllerDelegate?
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var returnDashboardButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        mainView.layer.cornerRadius = 5
        successView.layer.cornerRadius = successView.frame.height / 2
        returnDashboardButton.layer.cornerRadius = 5
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            delegate?.closeCancelOrderSuccessViewController()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if sender as! UIButton == returnDashboardButton {
            delegate?.returnToDashboardAction()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}
