//
//  TransactionTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.priceLabel.layer.cornerRadius = (self.priceLabel.frame.size.height / 2)
    }
    
}
