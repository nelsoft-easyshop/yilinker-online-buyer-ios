//
//  ProfileHeaderTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileAddressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }

    func initializeViews() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
}
