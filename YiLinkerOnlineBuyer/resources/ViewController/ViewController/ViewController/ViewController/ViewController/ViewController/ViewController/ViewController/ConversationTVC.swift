//
//  MessageTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ConversationTVC: UITableViewCell {

    @IBOutlet weak var user_thumbnail: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var user_message: UILabel!
    @IBOutlet weak var user_dt: UILabel!
    @IBOutlet weak var user_online: RoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
