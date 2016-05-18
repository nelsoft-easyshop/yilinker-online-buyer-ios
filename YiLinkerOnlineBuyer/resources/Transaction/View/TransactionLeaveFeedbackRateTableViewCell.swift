//
//  TransactionLeaveFeedbackRateTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionLeaveFeedbackRateTableViewCell Delegate method
protocol TransactionLeaveFeedbackRateTableViewCellDelegate {
    func rateItemQuality(rate: Int)
    func rateCommunication(rate: Int)
}

class TransactionLeaveFeedbackRateTableViewCell: UITableViewCell {

    // Buttons
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    @IBOutlet weak var starComm1Button: UIButton!
    @IBOutlet weak var starComm2Button: UIButton!
    @IBOutlet weak var starComm3Button: UIButton!
    @IBOutlet weak var starComm4Button: UIButton!
    @IBOutlet weak var starComm5Button: UIButton!
    
    // Labels
    @IBOutlet weak var itemQualityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rateThisLabel: UILabel!
    
    // Local Strings
    var titleLabelTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_INFO_LOCALIZE_KEY")
    var itemQualityTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_QUALITY_LOCALIZE_KEY")
    var communicationTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_COMMUNICATION_LOCALIZE_KEY")

    // Global variables
    var rateButtons: [UIButton] = []
    var rateCommButtons: [UIButton] = []
    var rate: Int = 0
    var rateComm: Int = 0

    // Initialize TransactionLeaveFeedbackRateTableViewCellDelegate
    var delegate: TransactionLeaveFeedbackRateTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rateButtons = [self.star1Button, self.star2Button, self.star3Button, self.star4Button, self.star5Button]
        self.rateCommButtons = [self.starComm1Button, self.starComm2Button, self.starComm3Button, self.starComm4Button, self.starComm5Button]
        
        // Set labels texts
        self.itemQualityLabel.text = self.itemQualityTitle
        self.rateThisLabel.text = self.communicationTitle
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Button Actions
    @IBAction func rate1Action(sender: AnyObject) {
        self.updateRate(1, type: 0, buttons: self.rateButtons)
    }
    
    @IBAction func rate2Action(sender: AnyObject) {
        self.updateRate(2, type: 0, buttons: self.rateButtons)
    }
    
    @IBAction func rate3Action(sender: AnyObject) {
        self.updateRate(3, type: 0, buttons: self.rateButtons)
    }
    
    @IBAction func rate4Action(sender: AnyObject) {
        self.updateRate(4, type: 0, buttons: self.rateButtons)
    }
    
    @IBAction func rate5Action(sender: AnyObject) {
        self.updateRate(5, type: 0, buttons: self.rateButtons)
    }
    
    @IBAction func rateComm1Action(sender: AnyObject) {
        self.updateRate(1, type: 1, buttons: self.rateCommButtons)
    }
    
    @IBAction func rateComm2Action(sender: AnyObject) {
        self.updateRate(2, type: 1, buttons: self.rateCommButtons)
    }
    
    @IBAction func rateComm3Action(sender: AnyObject) {
        self.updateRate(3, type: 1, buttons: self.rateCommButtons)
    }
    
    @IBAction func rateComm4Action(sender: AnyObject) {
        self.updateRate(4, type: 1, buttons: self.rateCommButtons)
    }
    
    @IBAction func rateComm5Action(sender: AnyObject) {
        self.updateRate(5, type: 1, buttons: self.rateCommButtons)
    }
    
    // MARK: Private methods
    // MARK: Set the selected stars for 'Item Quality' and 'Communication' based on the index value.
    func updateRate(index: Int, type: Int, buttons: [UIButton]) {
        self.rate = index
        if type == 0 {
           self.delegate?.rateItemQuality(self.rate)
        } else {
            self.delegate?.rateCommunication(self.rate)
        }
        
        for i in 0..<5 {
            if i < index {
                buttons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                buttons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            buttons[i].frame.size = CGSize(width: 35, height: 30)
        }
    }
}
