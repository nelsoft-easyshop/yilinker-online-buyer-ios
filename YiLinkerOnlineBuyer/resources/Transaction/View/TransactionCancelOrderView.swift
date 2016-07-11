//
//  TransactionCancelOrderView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionCancelOrderView Delegate methods
protocol TransactionCancelOrderViewDelegate {
    func showCancelOrder()
    func leaveProductFeedback(tag: Int)
}

class TransactionCancelOrderView: UIView {

    // Custom button and view
    @IBOutlet weak var leaveFeedbackButton: DynamicRoundedButton!
    @IBOutlet weak var cancelView: DynamicRoundedView!
    
    // Buttons
    @IBOutlet weak var cancelButton: UIButton!
    
    // Labels
    @IBOutlet weak var cancelOrderLabel: UILabel!
    @IBOutlet weak var contactCsrLabel: UILabel!
    
    @IBOutlet weak var contactCSRLabel: UILabel!
    // Initialize TransactionCancelOrderViewDelegate
    var delegate: TransactionCancelOrderViewDelegate?
    
    override func awakeFromNib() {
        var tap = UITapGestureRecognizer(target: self, action: "cancelOrder:")
        self.cancelOrderLabel.addGestureRecognizer(tap)
        self.cancelView.addGestureRecognizer(tap)
    }

    // MARK: Button actions
    @IBAction func cancelButtonAction(sender: AnyObject){
        self.delegate?.showCancelOrder()
    }
    
    @IBAction func leaveFeedback() {
        self.delegate?.leaveProductFeedback(self.leaveFeedbackButton.tag)
    }
    
    // MARK: cancelOrderLabel and cancelView action
    func cancelOrder(sender: AnyObject){
        self.delegate?.showCancelOrder()
    }
    
    func showCancelLabel() {
        contactCSRLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_CONTACT_CSR_LOCALIZE_KEY")
        leaveFeedbackButton.hidden = true
        cancelView.hidden = true
        contactCSRLabel.hidden = false
    }
    
}
