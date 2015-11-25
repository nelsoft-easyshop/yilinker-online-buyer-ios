//
//  DailyLoginCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/25/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol DailyLoginCollectionViewCellDelegate {
    func dailyLoginCollectionViewCellDidTapCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell)
}

class DailyLoginCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    var delegate: DailyLoginCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.productImageView.layer.cornerRadius = 5
        self.productImageView.userInteractionEnabled = true
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tap")
        self.productImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - Tap
    func tap() {
        self.delegate?.dailyLoginCollectionViewCellDidTapCell(self)
    }
}
