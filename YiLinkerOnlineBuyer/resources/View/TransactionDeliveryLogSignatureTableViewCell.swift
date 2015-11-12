//
//  TransactionDeliveryLogSignatureTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDeliveryLogSignatureTableViewCell: UITableViewCell {

    @IBOutlet weak var signatureImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeViews()
    }
    
    func initializeViews() {
        mainView.layer.cornerRadius = 8
    }
    
    func setActionType(type: String) {
        if type == "pickup-product" {
            typeLabel.text = "Pickup Product"
            iconImageView.image = UIImage(named: "product-1")
        } else if type == "in-transit" {
            typeLabel.text = "In Transit"
            iconImageView.image = UIImage(named: "transit")
        } else if type == "warehouse-checkin" {
            typeLabel.text = "Warehouse Checkin"
            iconImageView.image = UIImage(named: "warehouse")
        } else if type == "delivery-complete" {
            typeLabel.text = "Delivery Complete"
            iconImageView.image = UIImage(named: "complete")
        }
    }
    
}
