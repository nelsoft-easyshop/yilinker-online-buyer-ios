//
//  PaymentViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct PaymentStrings {
    static let howDoYou: String = StringHelper.localizedStringWithKey("HOW_DO_LOCALIZE_KEY")
    static let rememberPayment: String = StringHelper.localizedStringWithKey("REMEMBER_PAYMENT_LOCALIZE_KEY")
    static let deliverTo: String = StringHelper.localizedStringWithKey("DELIVER_TO_LOCALIZE_KEY")
    static let cod: String = StringHelper.localizedStringWithKey("COD_LOCALIZE_KEY")
    static let creditCard: String = StringHelper.localizedStringWithKey("CREDIT_CARD_LOCALIZE_KEY")
}

class PaymentViewController: UIViewController, PaymentTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var paymentType: PaymentType?
    var paymentHeader: PaymentTableViewCell?
    var paymentFooterView: DeliverToTableViewCell?
    
    //MARK: -
    //MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.tableView != nil {
            if SessionManager.rememberPaymentType() {
                self.paymentHeader!.cellSwitch.setOn(true, animated: false)
            } else {
                self.paymentHeader!.cellSwitch.setOn(false, animated: false)
                SessionManager.setPaymentType(PaymentType.COD)
            }
            
            if SessionManager.paymentType() == PaymentType.COD {
                self.paymentHeader!.selectPaymentType(Constants.Checkout.Payment.touchabelTagCOD)
            } else {
                self.paymentHeader!.selectPaymentType(Constants.Checkout.Payment.touchabelTagCreditCard)
            }
          
            paymentFooterView!.userNameLabel.text = SessionManager.userFullName()
            paymentFooterView!.addressLabel.text = SessionManager.userFullAddress()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if IphoneType.isIphone4() || IphoneType.isIphone5() {
            self.paymentHeader = XibHelper.puffViewWithNibName("PaymentTableViewCell", index: 1) as? PaymentTableViewCell
            self.paymentHeader!.delegate = self
            self.tableView.tableHeaderView = self.paymentHeader
            
            if SessionManager.rememberPaymentType() {
                self.paymentHeader!.cellSwitch.setOn(true, animated: false)
            } else {
                self.paymentHeader!.cellSwitch.setOn(false, animated: false)
                SessionManager.setPaymentType(PaymentType.COD)
            }
            
            if SessionManager.paymentType() == PaymentType.COD {
                 self.paymentHeader!.selectPaymentType(Constants.Checkout.Payment.touchabelTagCOD)
            } else {
                 self.paymentHeader!.selectPaymentType(Constants.Checkout.Payment.touchabelTagCreditCard)
            }
            
        } else {
            self.paymentHeader = XibHelper.puffViewWithNibName("PaymentTableViewCell", index: 0) as? PaymentTableViewCell
            self.paymentHeader!.delegate = self
            self.tableView.tableHeaderView = paymentHeader
            
            if SessionManager.rememberPaymentType() {
                self.paymentHeader!.cellSwitch.setOn(true, animated: false)
            } else {
                self.paymentHeader!.cellSwitch.setOn(false, animated: false)
            }
            
            if SessionManager.paymentType() == PaymentType.COD {
                self.paymentHeader!.selectPaymentType(Constants.Checkout.Payment.touchabelTagCOD)
            } else {
                self.paymentHeader!.selectPaymentType(Constants.Checkout.Payment.touchabelTagCreditCard)
            }
        }
        
        paymentFooterView = XibHelper.puffViewWithNibName("DeliverToTableViewCell", index: 0) as? DeliverToTableViewCell
        paymentFooterView!.userNameLabel.text = SessionManager.userFullName()
        paymentFooterView!.addressLabel.text = SessionManager.userFullAddress()
        
        self.tableView.tableFooterView = paymentFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //MARK: - 
    //MARK: - Payment Table View Cell
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
