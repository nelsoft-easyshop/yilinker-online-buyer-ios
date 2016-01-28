//
//  ActivityLogTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogTableViewCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    // Views
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeViews()
    }

    func initializeViews() {
        cellView.layer.cornerRadius = 8
    }

}
