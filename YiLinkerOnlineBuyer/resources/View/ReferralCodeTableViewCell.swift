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
}

class ReferralCodeTableViewCell: UITableViewCell {
    
    private static let nibNameAndIdentifierKey = "ReferralCodeTableViewCell"
    
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var referralPersonTextField: UITextField!
    @IBOutlet weak var referralPersonLabel: UILabel!
    @IBOutlet weak var yourReferralCodeTextField: UITextField!
    @IBOutlet weak var yourReferralCodeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
}
