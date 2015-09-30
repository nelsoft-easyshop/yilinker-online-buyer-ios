//
//  TransactionSectionFooterView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/11/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionSectionFooterViewDelegate {
    func leaveSellerFeedback(title: String, tag: Int)
    func messageSeller(sellerId: Int)
}

class TransactionSectionFooterView: UIView {

    @IBOutlet weak var leaveFeedbackButton: DynamicRoundedButton!
    
    @IBOutlet weak var messageButton: DynamicRoundedButton!
    @IBOutlet weak var sellerContactNumber: UILabel!
    
    @IBOutlet weak var sellerNameLabel: UILabel!
    
    @IBOutlet weak var sellerContactNumberTitle: UILabel!
    
    @IBOutlet weak var sellerNameLabelTitle: UILabel!
    
    var delegate: TransactionSectionFooterViewDelegate?
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        
    }
    
    @IBAction func leaveFeedback(sender: AnyObject) {
        println("leave feedback \(sender.titleLabel!!.text)")
        var label = sender.titleLabel!!.text
        var tag = sender.tag
        self.delegate?.leaveSellerFeedback(label!, tag: tag)
    }
    
    @IBAction func message(sender: AnyObject) {
        println("message")
        var tag = sender.tag
        self.delegate?.messageSeller(tag)
    }

}
