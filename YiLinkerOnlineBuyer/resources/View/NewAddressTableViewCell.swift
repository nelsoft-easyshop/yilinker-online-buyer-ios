//
//  NewAddressTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol NewAddressTableViewCellDelegate {
    func newAddressTableViewCell(didClickNext newAddressTableViewCell: NewAddressTableViewCell)
    func newAddressTableViewCell(didClickPrevious newAddressTableViewCell: NewAddressTableViewCell)
    
    func newAddressTableViewCell(didBeginEditing newAddressTableViewCell: NewAddressTableViewCell, index: Int)
}

class NewAddressTableViewCell: UITableViewCell, UITextFieldDelegate {
   
    @IBOutlet weak var rowTitleLabel: UILabel!
    @IBOutlet weak var rowTextField: UITextField!
    
    var delegate: NewAddressTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.rowTextField.delegate = self
        
//        self.rowTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.newAddressTableViewCell(didBeginEditing: self, index: self.tag)
    }
    
//    func next() {
//        self.delegate!.newAddressTableViewCell(didClickNext: self)
//    }
//    
//    func previous() {
//        self.delegate!.newAddressTableViewCell(didClickPrevious: self)
//    }
//    
//    func done() {
//        self.endEditing(true)
//    }
    
}
