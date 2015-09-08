//
//  MessageThreadTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/3/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class MessageThreadTVC: UITableViewCell {
    @IBOutlet weak var message_label: UILabel!
    
    @IBOutlet weak var messageContainerView: UIView!

    @IBOutlet weak var trailingSpaceToSeen: NSLayoutConstraint!
    
    @IBOutlet weak var timestamp_image: UIImageView!
    @IBOutlet weak var timestamp_label: UILabel!
    @IBOutlet weak var contact_image: UIImageView!
    
    @IBOutlet weak var resendButton: RoundedButton!
    @IBOutlet weak var seen_image: UIImageView!
    @IBOutlet weak var seen_label: UILabel!
    @IBOutlet weak var timestampLabelTrailingContraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var maxCellWidth = UIScreen.mainScreen().bounds.size.width * 0.55
        
        message_label.preferredMaxLayoutWidth = maxCellWidth
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSeenOff(mode: String){
        if (seen_image != nil){
            if(mode == "receiver"){
                seen_image.hidden = false
            } else if (mode == "sender"){
                seen_image.removeFromSuperview()
                self.removeConstraint(trailingSpaceToSeen)
            }
        }
        
        if (seen_label != nil){
            if(mode == "receiver"){
                seen_label.hidden = false
            } else if (mode == "sender"){
                seen_label.removeFromSuperview()
                timestampLabelTrailingContraint.constant = 10.0
            }
        }

    }
    
    
    
}
