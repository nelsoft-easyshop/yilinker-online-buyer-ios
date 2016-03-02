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

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var changeAddressLabel: UILabel!
    @IBOutlet weak var defaultAddressLabel: UILabel!
    @IBOutlet weak var fakeContainerView: UIView!
    @IBOutlet weak var shipToLabel: UILabel!
    
    var delegate: ShipToTableViewCellDelegate?
    
    @IBOutlet weak var arrowImageView: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.changeAddressLabel.userInteractionEnabled = false
        self.defaultAddressLabel.userInteractionEnabled = false
        
        let touchRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap")
        self.userInteractionEnabled = true
        self.addGestureRecognizer(touchRecognizer)
        
        self.shipToLabel.text = CheckoutStrings.shipTo
        self.defaultAddressLabel.text = CheckoutStrings.defaultAddress
        self.changeAddressLabel.text = CheckoutStrings.changeAddress
    }
    
    func tap() {
        self.delegate!.shipToTableViewCell(didTap: self)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
