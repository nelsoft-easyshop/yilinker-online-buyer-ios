//
//  ViewMoreFooterCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/2/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ViewMoreFooterCollectionViewCellDelegate {
    func didSelectViewMoreWithtarget(target: String, targetType: TargetType)
}

class ViewMoreFooterCollectionViewCell: UICollectionViewCell {
    
    var target: String = ""
    var targetType: TargetType = TargetType.ProductPage
    
    var delegate: ViewMoreFooterCollectionViewCellDelegate?
    @IBOutlet weak var cellButton: DynamicRoundedButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func fireViewMore(sender: UIButton) {
        self.delegate?.didSelectViewMoreWithtarget(self.target, targetType: self.targetType)
    }

}
