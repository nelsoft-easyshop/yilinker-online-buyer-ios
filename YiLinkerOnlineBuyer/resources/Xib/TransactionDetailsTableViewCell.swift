//
//  TransactionDetailsTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 11/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productStatusLabel: UILabel!
    @IBOutlet weak var orderProductNameLabel: UILabel!
    @IBOutlet weak var orderProductStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.orderProductNameLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_ORDER_PRODUCT_NAME_LOCALIZE_KEY")
        self.orderProductStatusLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_ORDER_PRODUCT_STATUS_LOCALIZE_KEY")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
