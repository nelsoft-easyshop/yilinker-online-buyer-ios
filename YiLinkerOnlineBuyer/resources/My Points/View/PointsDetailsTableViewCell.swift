//
//  PointsDetailsTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PointsDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailsLabel.text = StringHelper.localizedStringWithKey("MY_POINTS_DESCRIPTION_LOCALIZE_KEY")
    }

    func hide() {
        self.detailsLabel.text = ""
        self.topConstraint.constant = 0
        self.bottomConstraint.constant = 0
    }

}
