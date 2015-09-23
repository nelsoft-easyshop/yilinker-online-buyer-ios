//
//  ChangeAddressFooterCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangeAddressFooterCollectionViewCellDelegate {
    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell)
}

class ChangeAddressFooterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var newAddressButton: DynamicRoundedButton!
    var delegate: ChangeAddressFooterCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.newAddressButton.setTitle(AddressStrings.newAddress, forState: UIControlState.Normal)
    }
    
    @IBAction func newAddress(sender: AnyObject) {
        self.delegate?.changeAddressFooterCollectionViewCell(didSelecteAddAddress: self)
    }
}
