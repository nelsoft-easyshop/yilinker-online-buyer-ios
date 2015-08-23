//
//  ShipToTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ShipToTableViewCellDelegate {
    func shipToTableViewCell(didTap shipToTableViewCell: ShipToTableViewCell)
}

class ShipToTableViewCell: UITableViewCell {

    @IBOutlet weak var changeAddressLabel: UILabel!
    @IBOutlet weak var defaultAddressLabel: UILabel!
    @IBOutlet weak var fakeContainerView: UIView!
    
    var delegate: ShipToTableViewCellDelegate?
    
    @IBOutlet weak var arrowImageView: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.changeAddressLabel.userInteractionEnabled = false
        self.defaultAddressLabel.userInteractionEnabled = false
        
        let touchRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap")
        self.userInteractionEnabled = true
        self.addGestureRecognizer(touchRecognizer)
    }
    
    func tap() {
        self.delegate!.shipToTableViewCell(didTap: self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
