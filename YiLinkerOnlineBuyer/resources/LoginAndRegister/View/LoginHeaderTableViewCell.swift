//
//  TableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/26/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LoginHeaderTableViewCellDelegate {
    func loginHeaderTableViewCell(loginHeaderTableViewCell: LoginHeaderTableViewCell, didTapBack navBarButton: UIButton)
}

class LoginHeaderTableViewCell: UITableViewCell {
    
    var delegate: LoginHeaderTableViewCellDelegate?
    
    //MARK: - 
    //MARK: - Life Cycle
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setTitle(title: String) {
        self.navBar.topItem?.title = title
    }
    
    func setBackButtonToClose(close: Bool) {
        if close {
            self.navBarButton.setImage(UIImage(named: "filter-close"), forState: .Normal)
        } else{
            self.navBarButton.setImage(UIImage(named: "back-white"), forState: .Normal)
        }
    }
    
    @IBAction func backAction(sender: AnyObject) {
        self.delegate?.loginHeaderTableViewCell(self, didTapBack: self.navBarButton)
    }
}
