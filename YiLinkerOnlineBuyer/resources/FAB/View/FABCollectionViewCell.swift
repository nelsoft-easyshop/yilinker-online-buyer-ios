//
//  FABCollectionViewCell.swift
//  FloatingActionButton
//
//  Created by Alvin John Tandoc on 1/20/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

import UIKit

protocol FABCollectionViewCellDelegate {
    func fabCollectionViewCellDidTapCell(fabCollectionViewCell: UICollectionViewCell)
}

class FABCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var leftLabelWidth: NSLayoutConstraint!
    
    @IBOutlet weak var rightLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var iconButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var iconButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var leftLabel: DynamicRoundedLabel!
    @IBOutlet weak var rightLabel: DynamicRoundedLabel!
    @IBOutlet weak var iconButton: RoundedButton!
    
    var delegate: FABCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.speed = 2.0
    }
    
    //MARK: - 
    //MARK: - Tap
    @IBAction func tap(sender: AnyObject) {
        self.delegate!.fabCollectionViewCellDidTapCell(self)
    }
    
}
