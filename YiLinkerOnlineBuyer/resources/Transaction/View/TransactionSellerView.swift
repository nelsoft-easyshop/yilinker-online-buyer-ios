//
//  TransactionSellerView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionSellerView: UIView {
    
    // Buttons
    @IBOutlet weak var messageLabel: UIButton!
    
    // Imageviews
    @IBOutlet weak var smsImageView: UIImageView!
    @IBOutlet weak var callImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
    
        self.messageLabel.layer.borderWidth = 2.0
        self.messageLabel.layer.borderColor = Constants.Colors.productPrice.CGColor
        self.messageLabel.layer.cornerRadius = self.messageLabel.frame.size.height / 2
        
        self.addViewsActions()
    }
    
    // MARK: Private Methods
    // MARK: - Add actions in views and label
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
    
    // MARK: - Views and label actions
    func messageAction(gesture: UIGestureRecognizer) {
        
    }
    
    func smsAction(gesture: UIGestureRecognizer) {
        
    }
    
    func callAction(gesture: UIGestureRecognizer) {
        
    }
}
