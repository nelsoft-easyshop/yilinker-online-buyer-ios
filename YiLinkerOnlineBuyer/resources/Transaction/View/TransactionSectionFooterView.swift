//
//  TransactionSectionFooterView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/11/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionSectionFooterView Delegate methods
protocol TransactionSectionFooterViewDelegate {
    func leaveSellerFeedback(title: String, tag: Int)
    func messageSeller(sellerId: Int)
    func sellerPage(sellerId: Int)
}

class TransactionSectionFooterView: UIView {

    // Custom buttons
    @IBOutlet weak var leaveFeedbackButton: DynamicRoundedButton!
    @IBOutlet weak var messageButton: DynamicRoundedButton!
    
    // Buttons
    @IBOutlet weak var sellerStorePageButton: UIButton!
    
    // Labels
    @IBOutlet weak var sellerContactNumber: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sellerContactNumberTitle: UILabel!
    @IBOutlet weak var sellerNameLabelTitle: UILabel!
    
    // Initialize TransactionSectionFooterViewDelegate
    var delegate: TransactionSectionFooterViewDelegate?

    override func awakeFromNib() {
       
    }
    
    // MARK: Button actions
    @IBAction func leaveFeedback(sender: AnyObject) {
        var label = sender.titleLabel!!.text
        var tag = sender.tag
        self.delegate?.leaveSellerFeedback(label!, tag: tag)
    }
    
    @IBAction func message(sender: AnyObject) {
        var tag = sender.tag
        self.delegate?.messageSeller(tag)
    }
    
    @IBAction func goToSellerPage(sender: AnyObject) {
        var tag = self.sellerNameLabel.tag//sender.tag
        self.delegate?.sellerPage(tag)
    }
}
