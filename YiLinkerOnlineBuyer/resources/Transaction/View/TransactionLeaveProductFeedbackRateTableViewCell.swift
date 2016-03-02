//
//  TransactionLeaveProductFeedbackRateTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 12/14/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionLeaveProductFeedbackRateTableViewCellDelegate {
    func rate(rate: Int)
}

class TransactionLeaveProductFeedbackRateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    @IBOutlet weak var rateThisProductLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var titleLabelTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_INFO_LOCALIZE_KEY")
    var rateThisProduct =  StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_RATE_LOCALIZE_KEY")
    
    var rateButtons: [UIButton] = []
    var rate: Int = 0
    
    var delegate: TransactionLeaveProductFeedbackRateTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rateButtons = [star1Button, star2Button, star3Button, star4Button, star5Button]
        
        self.messageLabel.text = titleLabelTitle
        self.rateThisProductLabel.text = rateThisProduct
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    
    @IBAction func rate1Action(sender: AnyObject) {
        updateRate(1)
    }
    
    @IBAction func rate2Action(sender: AnyObject) {
        updateRate(2)
    }
    
    @IBAction func rate3Action(sender: AnyObject) {
        updateRate(3)
    }
    
    @IBAction func rate4Action(sender: AnyObject) {
        updateRate(4)
    }
    
    @IBAction func rate5Action(sender: AnyObject) {
        updateRate(5)
    }
    
    func updateRate(index: Int) {
        self.rate = index
        self.delegate?.rate(rate)
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

