//
//  TransactionDeliveryLog2TableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDeliveryLog2TableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var processImageView: UIView!
    @IBOutlet weak var processLabel: UIView!
    @IBOutlet weak var timeLabel: UIView!
    @IBOutlet weak var dateLabel: UIView!
    @IBOutlet weak var locationLabel: UIView!
    @IBOutlet weak var riderLabel: UIView!
    @IBOutlet weak var signatureImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = Constants.Colors.backgroundGray
        self.containerView.layer.cornerRadius = 8
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
