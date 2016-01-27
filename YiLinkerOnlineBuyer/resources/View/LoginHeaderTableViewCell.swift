//
//  TableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/26/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LoginHeaderTableViewCellDelegate {
    func loginHeaderTableViewCell(loginHeaderTableViewCell: LoginHeaderTableViewCell, didTapButton button: UIButton)
}

class LoginHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    @IBOutlet weak var crossOutButton: UIButton!
    
    var delegate: LoginHeaderTableViewCellDelegate?
    
    //MARK: - 
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCrossOutButton()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: -
    //MARK: - Activate Button
    func activateButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.backgroundColor = Constants.Colors.appTheme
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    //MARK: -
    //MARK: - De Activate Button
    func deActivateButton(button: UIButton) {
        button.layer.cornerRadius = 20
        button.backgroundColor = .clearColor()
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.layer.borderWidth = 1
        button.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
    }
    
    //MARK: - 
    //MARK: - Login
    @IBAction func login(sender: UIButton) {
        self.activateButton(self.loginButton)
        self.deActivateButton(self.registerButton)
        self.delegate?.loginHeaderTableViewCell(self, didTapButton: sender)
    }
    
    //MARK: -
    //MARK: - Register
    @IBAction func register(sender: UIButton) {
        self.activateButton(self.registerButton)
        self.deActivateButton(self.loginButton)
       self.delegate?.loginHeaderTableViewCell(self, didTapButton: sender)
    }
    
    //MARK: -
    //MARK: - Init Cross Out Button
    func initCrossOutButton() {
        self.crossOutButton.layer.cornerRadius = self.crossOutButton.frame.size.width / 2
        self.crossOutButton.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.crossOutButton.layer.borderWidth = 1
    }
    
    //MARK: - 
    //MARK: - Close
    @IBAction func close(sender: UIButton) {
        self.delegate?.loginHeaderTableViewCell(self, didTapButton: sender)
    }
}
