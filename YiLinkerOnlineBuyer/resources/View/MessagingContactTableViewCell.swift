//
//  MessagingContactTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/11/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        // Set senderImageView and statusView to circular
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.height / 2
        self.statusView.layer.cornerRadius = self.statusView.frame.height / 2
        
        // Set statusView border
        self.statusView.layer.borderColor = UIColor.whiteColor().CGColor
        self.statusView.layer.borderWidth = 1.0
    }
    
    func setIsOnline(isOnline: Bool) {
        if isOnline {
            self.statusView.backgroundColor = Constants.Colors.onlineColor
            self.statusLabel.text = MessagingLocalizedStrings.online
        } else {
            self.statusView.backgroundColor = Constants.Colors.offlineColor
            self.statusLabel.text = MessagingLocalizedStrings.offline
        }
    }
}
