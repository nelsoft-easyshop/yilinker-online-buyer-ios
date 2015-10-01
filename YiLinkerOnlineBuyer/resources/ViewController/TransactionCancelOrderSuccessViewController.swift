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
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var successSubLabel: UILabel!
    @IBOutlet weak var returnToDashboardButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var returnDashboardButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    var successTitle = StringHelper.localizedStringWithKey("TRANSACTION_CANCEL_ORDER_SUCCESS_LOCALIZE_KEY")
    var successSubTitle = StringHelper.localizedStringWithKey("TRANSACTION_CANCEL_ORDER_SUCCESS_SUB_LOCALIZE_KEY")
    var returnToDashboard = StringHelper.localizedStringWithKey("TRANSACTION_CANCEL_ORDER_RETURN_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        self.successLabel.text = successTitle
        self.successSubLabel.text = successSubTitle
        self.returnDashboardButton.setTitle(returnToDashboard, forState: UIControlState.Normal)
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
