//
//  TransactionLeaveFeedbackFieldTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionLeaveFeedbackFieldTableViewCell Delegate method
protocol TransactionLeaveFeedbackFieldTableViewCellDelegate {
    func submitAction(feedback: String)
}

class TransactionLeaveFeedbackFieldTableViewCell: UITableViewCell {
    
    // Buttons
    @IBOutlet weak var sendButton: UIButton!
    
    // Textfields
    @IBOutlet weak var inputTextField: UITextField!
    
    // Views
    @IBOutlet weak var typingAreaView: UIView!
    @IBOutlet weak var cameraView: UIView!
    
    // Local Strings
    var typeFeedback = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_TYPE_LOCALIZE_KEY")
    var sendTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_SEND_LOCALIZE_KEY")
    
    // Initialize TransactionLeaveFeedbackFieldTableViewCellDelegate
    var delegate: TransactionLeaveFeedbackFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cameraView.hidden = true
        self.inputTextField.placeholder = self.typeFeedback
        self.inputTextField.becomeFirstResponder()
        self.sendButton.setTitle(self.sendTitle, forState: UIControlState.Normal)
        self.typingAreaView.layer.borderWidth = 1.0
        self.typingAreaView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Button action
    @IBAction func submit(sender: AnyObject) {
        self.delegate!.submitAction(self.inputTextField.text)
    }
    
}
