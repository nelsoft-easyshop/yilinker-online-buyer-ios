//
//  TransactionLeaveProductFeedbackRateTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 12/14/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionLeaveProductFeedbackRateTableViewCell Delegate methods
protocol TransactionLeaveProductFeedbackRateTableViewCellDelegate {
    func rate(rate: Int)
}

class TransactionLeaveProductFeedbackRateTableViewCell: UITableViewCell {
    
    // Buttons
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    // Labels
    @IBOutlet weak var rateThisProductLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Local Strings
    var titleLabelTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_INFO_LOCALIZE_KEY")
    var rateThisProduct =  StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_RATE_LOCALIZE_KEY")
    
    // Global variables
    var rateButtons: [UIButton] = []
    var rate: Int = 0
    
    // Initialize TransactionLeaveProductFeedbackRateTableViewCellDelegate
    var delegate: TransactionLeaveProductFeedbackRateTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rateButtons = [self.star1Button, self.star2Button, self.star3Button, self.star4Button, self.star5Button]
        
        self.messageLabel.text = self.titleLabelTitle
        self.rateThisProductLabel.text = self.rateThisProduct
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Buttos Actions
    @IBAction func rate1Action(sender: AnyObject) {
        self.updateRate(1)
    }
    
    @IBAction func rate2Action(sender: AnyObject) {
        self.updateRate(2)
    }
    
    @IBAction func rate3Action(sender: AnyObject) {
        self.updateRate(3)
    }
    
    @IBAction func rate4Action(sender: AnyObject) {
        self.updateRate(4)
    }
    
    @IBAction func rate5Action(sender: AnyObject) {
        self.updateRate(5)
    }
    
    func updateRate(index: Int) {
        self.rate = index
        self.delegate?.rate(self.rate)
        for i in 0..<5 {
            if i < index {
                self.rateButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            self.rateButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
    }
}

