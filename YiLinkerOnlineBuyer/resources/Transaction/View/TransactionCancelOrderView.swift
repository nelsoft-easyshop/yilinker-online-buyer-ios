//
//  TransactionCancelOrderView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionCancelOrderViewDelegate {
    func showCancelOrder()
    func leaveProductFeedback(tag: Int)
}

class TransactionCancelOrderView: UIView {

    @IBOutlet weak var cancelOrderLabel: UILabel!
    @IBOutlet weak var cancelView: DynamicRoundedView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var leaveFeedbackButton: DynamicRoundedButton!
    
    var delegate: TransactionCancelOrderViewDelegate?
    override func awakeFromNib() {
        
        var tap = UITapGestureRecognizer(target: self, action: "cancelOrder:")
        cancelOrderLabel.addGestureRecognizer(tap)
        cancelView.addGestureRecognizer(tap)
        
    }
    
    func cancelOrder(sender: AnyObject){
        println("cancel order")
        self.delegate?.showCancelOrder()
    }

    @IBAction func cancelButtonAction(sender: AnyObject){
        self.delegate?.showCancelOrder()
    }
    
    @IBAction func leaveFeedback() {
        self.delegate?.leaveProductFeedback(self.leaveFeedbackButton.tag)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
