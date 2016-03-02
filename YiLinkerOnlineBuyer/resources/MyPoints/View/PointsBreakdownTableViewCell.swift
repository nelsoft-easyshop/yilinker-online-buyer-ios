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
    @IBOutlet weak var howToButton: SemiRoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        delegate?.howToEarnActionForIndex(self)
    }

}
