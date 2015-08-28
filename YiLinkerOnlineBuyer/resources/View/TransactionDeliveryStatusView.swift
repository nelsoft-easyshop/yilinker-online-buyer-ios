//
//  TransactionDeliveryStatusView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDeliveryStatusView: UIView {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameAndPlaceLabel: UILabel!
    @IBOutlet weak var pickupRiderLabel: UILabel!
    @IBOutlet weak var deliveryRiderLabel: UILabel!
    
    @IBOutlet weak var pickupSms: UIImageView!
    @IBOutlet weak var pickupCall: UIImageView!
    
    @IBOutlet weak var deliverySms: UIImageView!
    @IBOutlet weak var deliveryCall: UIImageView!
    
    @IBOutlet weak var arrowImageView: UIImageView!

    
    override func awakeFromNib() {
        
        
        addViewsActions()
    }

    // MARK: - Actions
    
    func pickupSmsAction(gesture: UIGestureRecognizer) {
        println("pickup sms")
    }
    
    func pickupCallAction(gesture: UIGestureRecognizer) {
        println("pickup call")
    }
    
    func deliverySmsAction(gesture: UIGestureRecognizer) {
        println("delivery sms")
    }
    
    func deliveryCallAction(gesture: UIGestureRecognizer) {
        println("delivery call")
    }
    
    func arrowImageViewAction(gesture: UIGestureRecognizer) {
        println("arrow action")
    }
    
    
    
    // MARK: - Methods
    
    func addViewsActions() {
        self.pickupSms.addGestureRecognizer(tap("pickupSmsAction:"))
        self.pickupCall.addGestureRecognizer(tap("pickupCallAction:"))
        self.deliverySms.addGestureRecognizer(tap("deliverySmsAction:"))
        self.deliveryCall.addGestureRecognizer(tap("deliveryCallAction:"))
        self.arrowImageView.addGestureRecognizer(tap("arrowImageViewAction:"))
    }
    
    func tap(action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        return tap
    }
    
}
