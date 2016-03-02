//
//  TransactionLeaveFeedbackRateTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionLeaveFeedbackRateTableViewCellDelegate {
    func rateItemQuality(rate: Int)
    func rateCommunication(rate: Int)
}

class TransactionLeaveFeedbackRateTableViewCell: UITableViewCell {

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
    
    @IBOutlet weak var itemQualityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rateThisLabel: UILabel!
    
    var titleLabelTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_INFO_LOCALIZE_KEY")
    var itemQualityTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_QUALITY_LOCALIZE_KEY")
    var communicationTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_COMMUNICATION_LOCALIZE_KEY")

    var rateButtons: [UIButton] = []
    var rateCommButtons: [UIButton] = []
    var rate: Int = 0
    var rateComm: Int = 0

    var delegate: TransactionLeaveFeedbackRateTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rateButtons = [star1Button, star2Button, star3Button, star4Button, star5Button]
        rateCommButtons = [starComm1Button, starComm2Button, starComm3Button, starComm4Button, starComm5Button]
        
        self.itemQualityLabel.text = itemQualityTitle
        self.rateThisLabel.text = communicationTitle
        
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
    
    @IBAction func rateComm1Action(sender: AnyObject) {
        updateCommRate(1)
    }
    
    @IBAction func rateComm2Action(sender: AnyObject) {
        updateCommRate(2)
    }
    
    @IBAction func rateComm3Action(sender: AnyObject) {
        updateCommRate(3)
    }
    
    @IBAction func rateComm4Action(sender: AnyObject) {
        updateCommRate(4)
    }
    
    @IBAction func rateComm5Action(sender: AnyObject) {
        updateCommRate(5)
    }
    
    func updateRate(index: Int) {
        self.rate = index
        self.delegate?.rateItemQuality(self.rate)
        for i in 0..<5 {
            
            if i < index {
                self.rateButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            self.rateButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
        
    }
    
    func updateCommRate(index: Int) {
        self.rateComm = index
        self.delegate?.rateCommunication(self.rateComm)
        for i in 0..<5 {
            
            if i < index {
                self.rateCommButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateCommButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            
            self.rateCommButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
    }

}
