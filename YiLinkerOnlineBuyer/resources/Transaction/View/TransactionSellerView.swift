//
//  TransactionSellerView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionSellerView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var messageLabel: UIButton!
    @IBOutlet weak var smsImageView: UIImageView!
    @IBOutlet weak var callImageView: UIImageView!
    
    override func awakeFromNib() {
        self.messageLabel.layer.cornerRadius = self.messageLabel.frame.size.height / 2
        self.messageLabel.layer.borderWidth = 2.0
        self.messageLabel.layer.borderColor = Constants.Colors.productPrice.CGColor
        
        addViewsActions()
    }
    
    // MARK: - Actions
    
    func messageAction(gesture: UIGestureRecognizer) {
        println("message")
    }
    
    func smsAction(gesture: UIGestureRecognizer) {
        println("sms")
    }
    
    func callAction(gesture: UIGestureRecognizer) {
        println("call")
    }
    
    // MARK: - Methods
    
    func addViewsActions() {
        self.messageLabel.addGestureRecognizer(tap("messageAction:"))
        self.smsImageView.addGestureRecognizer(tap("smsAction:"))
        self.callImageView.addGestureRecognizer(tap("callAction:"))
    }
    
    func tap(action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        return tap
    }
}
