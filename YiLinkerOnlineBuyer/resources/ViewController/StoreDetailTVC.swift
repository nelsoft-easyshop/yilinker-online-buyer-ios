//
//  StoreDetailTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/23/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class StoreDetailTVC: UITableViewCell {

    @IBOutlet weak var checkDefault: CheckBox!
    
    @IBOutlet weak var detail1Label: UILabel!
    @IBOutlet weak var detail2Label: UILabel!
    @IBOutlet weak var detail3Label: UILabel!
    @IBOutlet weak var detail4Label: UILabel!
    
    @IBOutlet weak var detailView: RoundedViewLight!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDefault(status : Bool){
        if (status) {
            self.detailView.layer.borderColor = checkDefault.checkedColorWay
            self.detailView.layer.borderWidth = 2.0
            self.detailView.layer.masksToBounds = true
        } else {
            self.detailView.layer.borderWidth = 0
        }
        self.checkDefault.setChecked(status)
    }
    
    @IBAction func onCheck(sender: CheckBox) {
        setDefault(sender.status)
    }

}
