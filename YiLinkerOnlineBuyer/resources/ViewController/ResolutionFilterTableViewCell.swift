//
//  ResolutionFilterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var isDate: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }
    
    func initializeViews() {
        checkView.layer.cornerRadius = 5
    }
    
    func setType(type: Int) { // type=0 dates section, type=1 others
        if type == 0 {
            isDate = true
        } else {
            isDate = false
        }
    }
    
    func setTitleLabelText(text: String) {
        titleLabel.text = text
    }
    
    func setChecked(isChecked: Bool) {
        if isChecked {
            if isDate {
                checkView.hidden = false
                checkImageView.hidden = false
                checkView.backgroundColor = UIColor.whiteColor()
                checkImageView.image = UIImage(named: "checkDate")
            } else {
                checkView.hidden = false
                checkImageView.hidden = false
                checkView.backgroundColor = Constants.Colors.transactionGreen
                checkImageView.image = UIImage(named: "checkDateWhite")
            }
        } else {
            if isDate {
                checkView.hidden = true
            } else {
                checkView.hidden = false
                checkImageView.hidden = true
                checkView.backgroundColor = Constants.Colors.transactionGrey
            }
        }
    }
}
