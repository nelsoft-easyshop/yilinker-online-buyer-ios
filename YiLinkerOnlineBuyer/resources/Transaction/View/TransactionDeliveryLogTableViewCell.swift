//
//  TransactionDeliveryLogTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDeliveryLogTableViewCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
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
}
