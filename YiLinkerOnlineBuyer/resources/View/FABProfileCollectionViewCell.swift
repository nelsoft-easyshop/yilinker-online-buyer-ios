//
//  FABProfileCollectionViewCell.swift
//  FloatingActionButton
//
//  Created by Alvin John Tandoc on 1/20/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

import UIKit

protocol FABProfileCollectionViewCellDelegate {
    func fABProfileCollectionViewCellDidTap(fABProfileCollectionViewCell: FABProfileCollectionViewCell)
}

class FABProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var leftLabel: DynamicRoundedLabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: RoundedButton!
    
    var delegate: FABCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.speed = 2.0
    }
    
    //MARK: - 
    //MARK: - Tap
    @IBAction func tap(sender: AnyObject) {
        self.delegate?.fabCollectionViewCellDidTapCell(self)
    }
}
