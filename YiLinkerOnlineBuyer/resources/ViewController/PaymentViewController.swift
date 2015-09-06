//
//  PaymentViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, PaymentTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var paymentType: PaymentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            let paymentHeader: PaymentTableViewCell = XibHelper.puffViewWithNibName("PaymentTableViewCell", index: 1) as! PaymentTableViewCell
            paymentHeader.delegate = self
            self.tableView.tableHeaderView = paymentHeader
            
            if SessionManager.rememberPaymentType() {
                paymentHeader.cellSwitch.setOn(true, animated: false)
            } else {
                paymentHeader.cellSwitch.setOn(false, animated: false)
                SessionManager.setPaymentType(PaymentType.COD)
            }
            
            if SessionManager.paymentType() == PaymentType.COD {
                 paymentHeader.selectPaymentType(Constants.Checkout.Payment.touchabelTagCOD)
            } else {
                 paymentHeader.selectPaymentType(Constants.Checkout.Payment.touchabelTagCreditCard)
            }
            
        } else {
            let paymentHeader: PaymentTableViewCell = XibHelper.puffViewWithNibName("PaymentTableViewCell", index: 0) as! PaymentTableViewCell
            paymentHeader.delegate = self
            self.tableView.tableHeaderView = paymentHeader
            paymentHeader.selectPaymentType(Constants.Checkout.Payment.touchabelTagCOD)
            
            if SessionManager.rememberPaymentType() {
                paymentHeader.cellSwitch.setOn(true, animated: false)
            } else {
                paymentHeader.cellSwitch.setOn(false, animated: false)
            }
            
            if SessionManager.paymentType() == PaymentType.COD {
                paymentHeader.selectPaymentType(Constants.Checkout.Payment.touchabelTagCOD)
            } else {
                paymentHeader.selectPaymentType(Constants.Checkout.Payment.touchabelTagCreditCard)
            }
        }
        
        let paymentFooterView: DeliverToTableViewCell = XibHelper.puffViewWithNibName("DeliverToTableViewCell", index: 0) as! DeliverToTableViewCell
        paymentFooterView.userNameLabel.text = SessionManager.userFullName()
        paymentFooterView.addressLabel.text = SessionManager.userFullAddress()
        
        self.tableView.tableFooterView = paymentFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func paymentTableViewCell(didChoosePaymentType paymentType: PaymentType) {
        self.paymentType = paymentType
        SessionManager.setPaymentType(paymentType)
    }
    
    func paymentTableViewCell(rememberPaymentType result: Bool) {
        SessionManager.setRememberPaymentType(result)
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
