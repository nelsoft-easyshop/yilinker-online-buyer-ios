//
//  ReferralCodeTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 2/1/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct ReferralStrings {
    static let referral: String = StringHelper.localizedStringWithKey("REFERRAL_LOCALIZE_KEY")
    static let yourReferral: String = StringHelper.localizedStringWithKey("YOUR_REFERRAL_LOCALIZE_KEY")
    static let referralPerson: String = StringHelper.localizedStringWithKey("REFERRAL_PERSON_LOCALIZE_KEY")
}

protocol ReferralCodeTableViewCellDelegate {
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didClickCopyButtonWithString yourReferralCodeTextFieldText: String)
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didTappedReturn textField: UITextField)
    func referralCodeTableViewCell(referralCodeTableViewCell: ReferralCodeTableViewCell, didChangeValueAtTextField textField: UITextField, textValue: String)
}

class ReferralCodeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private static let nibNameAndIdentifierKey = "ReferralCodeTableViewCell"
    
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var referralPersonTextField: UITextField!
    @IBOutlet weak var referralPersonLabel: UILabel!
    @IBOutlet weak var yourReferralCodeTextField: UITextField!
    @IBOutlet weak var yourReferralCodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isFromQRScanner: Bool = false
    
    var delegate: ReferralCodeTableViewCellDelegate?
    
    //MARK: -
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.copyButton.layer.cornerRadius = 8
        self.titleLabel.text = ReferralStrings.referral
        self.yourReferralCodeLabel.text = ReferralStrings.yourReferral
        self.referralPersonLabel.text = ReferralStrings.referralPerson
        
        self.referralPersonTextField.delegate = self
        
        self.referralPersonTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: -
    //MARK: - Copy Action
    @IBAction func copyAction(sender: AnyObject) {
        self.delegate?.referralCodeTableViewCell(self, didClickCopyButtonWithString: self.yourReferralCodeTextField.text)
    }
    
    //MARK: - 
    //MARK: - Nib Name And Identifier
    class func nibNameAndIdentifier()  -> String {
        return ReferralCodeTableViewCell.nibNameAndIdentifierKey
    }
    
    //MARK: - 
    //MARK: - Set Your Referral Code With Code
    func setYourReferralCodeWithCode(code: String) {
        self.yourReferralCodeTextField.text = code
        self.yourReferralCodeTextField.enabled = false
    }
    
    //MARK: -
    //MARK: - Set Referrer Code With Code
    func setReferrerCodeWithCode(code: String) {
        self.referralPersonTextField.text = code
        self.referralPersonTextField.enabled = self.isFromQRScanner
    }
    
    //MARK: - 
    //MARK: - Text Field Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.delegate?.referralCodeTableViewCell(self, didTappedReturn: textField)
       return true
    }
    
    func textFieldDidChange(textField: UITextField) {
        self.delegate?.referralCodeTableViewCell(self, didChangeValueAtTextField: textField, textValue: textField.text)
    }
}
