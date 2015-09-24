//
//  ResolutionCenterCell.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResolutionCenterCell: UITableViewCell {
    @IBOutlet private weak var imageStatus: UIImageView!
    @IBOutlet private weak var viewStatus: UIView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var userTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data: ResolutionCenterElement) {
        self.idLabel.text = data.ticketId
        self.dateLabel.text = data.date
        self.userTypeLabel.text = data.type
        self.viewStatus.layer.cornerRadius = self.viewStatus.bounds.size.width / 2

        if( data.status == "Open" ) {
            self.imageStatus.image = UIImage(named: "status-open")
            self.viewStatus.backgroundColor = UIColor(red:0.28, green:0.71, blue:0.00, alpha:1.0)
        }
        else {
            self.imageStatus.image = UIImage(named: "status-closed")
            self.viewStatus.backgroundColor = UIColor(red:0.70, green:0.70, blue:0.70, alpha:1.0)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
