//
//  TransactionDeliveryLogSignatureTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDeliveryLogSignatureTableViewCell: UITableViewCell {
    
    // Imageviews
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var signatureImageView: UIImageView!
    
    // Labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    // Views
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeViews()
    }
    
    // MARK: Set rounded corner of mainView
    func initializeViews() {
        self.mainView.layer.cornerRadius = 8
    }
    
    // MARK: Set action type image and text depending on the passed parameter in 'type'
    func setActionType(type: String) {
        if type == "pickup-product" {
            self.typeLabel.text = "Pickup Product"
            self.iconImageView.image = UIImage(named: "product-1")
        } else if type == "in-transit" {
            self.typeLabel.text = "In Transit"
            self.iconImageView.image = UIImage(named: "transit")
        } else if type == "warehouse-checkin" {
            self.typeLabel.text = "Warehouse Checkin"
            self.iconImageView.image = UIImage(named: "warehouse")
        } else if type == "delivery-complete" {
            self.typeLabel.text = "Delivery Complete"
            self.iconImageView.image = UIImage(named: "complete")
        }
    }
}
