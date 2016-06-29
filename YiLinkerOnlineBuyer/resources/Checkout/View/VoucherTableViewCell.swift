//
//  VoucherTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol VoucherTableViewCellDelegate {
    func voucherTableViewCell(didTapAddButton cell: VoucherTableViewCell)
    func voucherTableViewCell(textFieldDidChange cell: VoucherTableViewCell)
    func voucherTableViewCell(voucherTableViewCell: VoucherTableViewCell, startEditingAtTextField textField: UITextField)
}

class VoucherTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var addTextField: UIButton!
    @IBOutlet weak var voucherTextField: UITextField!
    @IBOutlet weak var voucherLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    var delegate: VoucherTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.voucherTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        self.addButton.layer.cornerRadius = 5
        
        if count(self.voucherTextField.text) < 6 {
            self.addButton.enabled = false
        }
        
        self.voucherTextField.delegate = self
        self.voucherLabel.text = StringHelper.localizedStringWithKey("VOUCHER_CODE_LOCALIZE_KEY")
        self.addButton.setTitle(StringHelper.localizedStringWithKey("ADD_LOCALIZE_KEY"), forState: UIControlState.Normal)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: - Add Action
    @IBAction func add(sender: AnyObject) {
        self.delegate?.voucherTableViewCell(didTapAddButton: self)
    }
    
    //MARK: -
    //MARK: - Textfield Did Change
    func textFieldDidChange(textField: UITextField) { //Handle the text changes here
        self.delegate?.voucherTableViewCell(textFieldDidChange: self)
    }
    
    //MARK: - 
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.delegate?.voucherTableViewCell(self, startEditingAtTextField: textField)
        return true
    }
}
