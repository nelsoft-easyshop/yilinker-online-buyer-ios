//
//  FilterFooterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/6/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FilterFooterTableViewCellDelegate {
    func filterFooterTableViewCell(filterFooterTableViewCell: FilterFooterTableViewCell, didTapAppllyFilter button: UIButton)
}

class FilterFooterTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "FilterFooterTableViewCell"
    
    var delegate: FilterFooterTableViewCellDelegate?

    @IBOutlet weak var applyFilterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == self.applyFilterButton {
//            self.delegate!.filterFooterTableViewCell
        }
    }
    
}
