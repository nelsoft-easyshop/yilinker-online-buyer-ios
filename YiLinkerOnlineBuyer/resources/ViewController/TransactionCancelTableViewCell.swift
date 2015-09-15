//
//  TransactionCancelTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionCancelTableViewCell: UITableViewCell {

    @IBOutlet weak var cancelView: DynamicRoundedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var tapCancel = UITapGestureRecognizer(target: self, action: "cancelOrder:")
        cancelView.addGestureRecognizer(tapCancel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func cancelOrder(gesture: UIGestureRecognizer) {
        
    }
}
