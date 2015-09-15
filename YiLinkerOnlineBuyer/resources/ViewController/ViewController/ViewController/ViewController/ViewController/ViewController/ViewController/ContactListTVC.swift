//
//  ContactListTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/14/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ContactListTVC: UITableViewCell {

    @IBOutlet weak var profile_image: UIImageView!
    
    @IBOutlet weak var user_name: UILabel!
    
    @IBOutlet weak var online_text: UILabel!
    
    @IBOutlet weak var online_view: RoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}
