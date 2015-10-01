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
    var dimView: UIView!
    
    var successTitle = StringHelper.localizedStringWithKey("TRANSACTION_CANCEL_ORDER_SUCCESS_LOCALIZE_KEY")
    var successSubTitle = StringHelper.localizedStringWithKey("TRANSACTION_CANCEL_ORDER_SUCCESS_SUB_LOCALIZE_KEY")
    var returnToDashboard = StringHelper.localizedStringWithKey("TRANSACTION_CANCEL_ORDER_RETURN_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
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
        self.showView()
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            delegate?.closeCancelOrderSuccessViewController()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if sender as! UIButton == returnDashboardButton {
            delegate?.returnToDashboardAction()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        self.dismissView()
    }
    
    func showView(){
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = false
            self.dimView.alpha = 0.5
            //self.dimView.layer.zPosition = 2
            //self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
        })
    }
    
    //MARK: TransactionCancelViewControllerDelegate
    func dismissView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = true
            //self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            //self.dimView.layer.zPosition = -1
        })
    }
}
