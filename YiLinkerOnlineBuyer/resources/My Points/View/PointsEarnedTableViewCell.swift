//
//  PointsEarnedTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PointsEarnedTableViewCell: UITableViewCell {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var pointsEarnedLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        pointsEarnedLabel.text = StringHelper.localizedStringWithKey("POINTS_EARNED_LOCALIZE_KEY")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
