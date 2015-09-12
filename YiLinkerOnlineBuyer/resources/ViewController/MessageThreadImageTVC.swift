//
//  MessageThreadImageTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/6/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class MessageThreadImageTVC: UITableViewCell {
    
    @IBOutlet weak var message_image: UIImageView!
    @IBOutlet weak var timestamp_label: UILabel!
    @IBOutlet weak var contact_image: UIImageView!

    @IBOutlet weak var timestamp_image: UIImageView!
    @IBOutlet weak var resendButton: RoundedButton!
    @IBOutlet weak var seen_image: UIImageView!
    @IBOutlet weak var seen_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSeen(){
        if (seen_image != nil){
            seen_image.hidden = false
        }
        
        if (seen_label != nil){
            seen_label.hidden = false
        }
        
    }

}
