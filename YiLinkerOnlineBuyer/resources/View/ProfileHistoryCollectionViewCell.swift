//
//  ProfileHistoryCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/14/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileHistoryCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var statusLabel: DynamicRoundedLabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: RoundedLabel!
    @IBOutlet weak var orderHistoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
