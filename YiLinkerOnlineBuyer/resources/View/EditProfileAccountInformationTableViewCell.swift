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
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }
    
    func initializeViews() {
        saveButton.layer.cornerRadius = 8
        changeEmailButton.layer.cornerRadius = 8
        changePasswordButton.layer.cornerRadius = 8
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        delegate?.saveAction(self)
    }
    
    @IBAction func changeAction(sender: AnyObject) {
    }

}
