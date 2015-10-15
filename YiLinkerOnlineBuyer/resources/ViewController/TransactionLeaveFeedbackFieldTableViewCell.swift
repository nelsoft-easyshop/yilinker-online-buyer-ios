//
//  TransactionLeaveFeedbackFieldTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionLeaveFeedbackFieldTableViewCellDelegate {
    func submitAction(feedback: String)
}

class TransactionLeaveFeedbackFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var typingAreaView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var typeFeedback = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_TYPE_LOCALIZE_KEY")
    var sendTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_SEND_LOCALIZE_KEY")
    
    var delegate: TransactionLeaveFeedbackFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.inputTextField.placeholder = typeFeedback
        self.sendButton.setTitle(sendTitle, forState: UIControlState.Normal)
        self.cameraView.hidden = true
        self.typingAreaView.layer.borderWidth = 1.0
        self.typingAreaView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.inputTextField.becomeFirstResponder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func submit(sender: AnyObject) {
        self.delegate?.submitAction(self.inputTextField.text)
    }
    
}
