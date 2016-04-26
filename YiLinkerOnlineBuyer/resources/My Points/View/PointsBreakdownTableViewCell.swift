//
//  PointsBreakdownTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol PointsBreakdownTableViewCellDelegate{
    func howToEarnActionForIndex(sender: AnyObject)
}

class PointsBreakdownTableViewCell: UITableViewCell {
    
    var delegate: PointsBreakdownTableViewCellDelegate?

    @IBOutlet weak var breakDownView: UIView!
    @IBOutlet weak var howToButton: UIButton!
    @IBOutlet weak var breakDownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        howToButton.layer.cornerRadius = 5
        howToButton.setTitle(StringHelper.localizedStringWithKey("EARN_MORE_POINTS_LOCALIZE_KEY"), forState: UIControlState.Normal)
        breakDownLabel.text = StringHelper.localizedStringWithKey("BREAKDOWN_LOCALIZE_KEY")
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        delegate?.howToEarnActionForIndex(self)
    }

}
