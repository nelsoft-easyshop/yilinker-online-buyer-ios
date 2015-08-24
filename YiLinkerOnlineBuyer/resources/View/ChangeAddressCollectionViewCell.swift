//
//  ChangeAddressCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangeAddressCollectionViewCellDelegate {
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell)
}

class ChangeAddressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var checkBoxButton: SemiRoundedButton!
    @IBOutlet weak var deleteButton: UIButton!
    var delegate: ChangeAddressCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteIndexPath(sender: AnyObject) {
        self.delegate?.changeAddressCollectionViewCell(deleteAddressWithCell: self)
    }
}
