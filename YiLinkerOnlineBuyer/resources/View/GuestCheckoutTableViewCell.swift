//
//  GuestCheckoutTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol GuestCheckoutTableViewCellDelegate {
    
}


class GuestCheckoutTableViewCell: UITableViewCell {
  
    @IBOutlet weak var fakeContainerView: UIView!
    
    var delegate: GuestCheckoutTableViewCellDelegate?
    
    @IBOutlet weak var arrowImageView: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
   
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
