//
//  TransactionDetailsView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDetailsView: UIView {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var unitCostLabel: UILabel!
    @IBOutlet weak var shippingFeeLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    override func awakeFromNib() {
        self.statusLabel.layer.cornerRadius = self.statusLabel.frame.size.height / 2
    }
}
