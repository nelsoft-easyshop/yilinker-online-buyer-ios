//
//  EditProfileAccountInformationTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol EditProfileAccountInformationTableViewCellDelegate{
    func saveAction(sender: AnyObject)
}

class EditProfileAccountInformationTableViewCell: UITableViewCell {

    var delegate: EditProfileAccountInformationTableViewCellDelegate?
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        delegate?.saveAction(self)
    }

}
