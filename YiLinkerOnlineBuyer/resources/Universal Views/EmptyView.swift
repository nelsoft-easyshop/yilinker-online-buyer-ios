//
//  EmptyView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


struct EmptyViewStrings {
    static let title: String = StringHelper.localizedStringWithKey("CONNECTION_TITLE_LOCALIZE_KEY")
    static let message: String = StringHelper.localizedStringWithKey("CONNECTION_MESSAGE_LOCALIZE_KEY")
    static let tap: String = StringHelper.localizedStringWithKey("CONNECTION_TAP_TO_RELOAD_LOCALIZE_KEY")
}

protocol EmptyViewDelegate {
    func didTapReload()
}

class EmptyView: UIView {
    
    var delegate: EmptyViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tapToReloadLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.text = EmptyViewStrings.title
        self.messageLabel.text = EmptyViewStrings.message
        self.tapToReloadLabel.text = EmptyViewStrings.tap
    }
    
    @IBAction func tapToReload(sender: AnyObject) {
        self.delegate?.didTapReload()
    }
    
}
