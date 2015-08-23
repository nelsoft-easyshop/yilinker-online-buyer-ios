//
//  DeliveryLogTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/21/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class DeliveryLogTVC: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var deliveryStatusImage: UIImageView!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var deliveryStatusTime: UILabel!
    @IBOutlet weak var statusDateLabel: UILabel!
    @IBOutlet weak var statusLocationLabel: UILabel!
    @IBOutlet weak var statusRiderLabel: UILabel!
    @IBOutlet weak var clientSignatureImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusView.layer.cornerRadius = 5.0
        statusView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
