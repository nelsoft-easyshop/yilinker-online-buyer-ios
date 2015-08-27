//
//  EditProfileAddressTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol EditProfileAddressTableViewCellDelegate{
    func changeAddressAction(sender: AnyObject)
}

class EditProfileAddressTableViewCell: UITableViewCell {
    
    var delegate: EditProfileAddressTableViewCellDelegate?

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTitleLabel: UILabel!
    @IBOutlet weak var changeAddressButton: UIButton!
    @IBOutlet weak var changeAdressIconButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        addressLabel.sizeToFit()
        addressLabel.text = "LG Sta. Lucia East Grand Mall,\nMarcos Highway Corner Felix Avenue,\nOrtigas, Pasig City"
    }
    
    @IBAction func changeAddressAction(sender: AnyObject) {
        delegate?.changeAddressAction(self)
    }

}
