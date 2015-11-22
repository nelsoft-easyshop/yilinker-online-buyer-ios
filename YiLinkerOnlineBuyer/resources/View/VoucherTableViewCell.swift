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
}

class VoucherTableViewCell: UITableViewCell {
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
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK: - Add Action
    @IBAction func add(sender: AnyObject) {
        self.delegate?.voucherTableViewCell(didTapAddButton: self)
    }
    
    //MARK: - Textfield Did Change
    func textFieldDidChange(textField: UITextField) { //Handle the text changes here
        self.delegate?.voucherTableViewCell(textFieldDidChange: self)
    }
}
