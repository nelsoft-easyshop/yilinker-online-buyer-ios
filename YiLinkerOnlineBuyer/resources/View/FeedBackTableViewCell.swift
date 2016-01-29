//
//  FeedBackTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/27/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FeedBackTableViewCellDelegate {
    func feedBackTableViewCell(feedBackTableViewCell: FeedBackTableViewCell, didTapCancel cancelButton: UIButton)
}

class FeedBackTableViewCell: UITableViewCell {

    @IBOutlet weak var starFrameView: UIView!
    @IBOutlet weak var rateFrameView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!       
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: FeedBackTableViewCellDelegate?
    
    @IBOutlet weak var starOneButton: UIButton!
    @IBOutlet weak var starTwoButton: UIButton!
    @IBOutlet weak var starThreeButton: UIButton!
    @IBOutlet weak var starFourButton: UIButton!
    @IBOutlet weak var starFiveButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rateFrameView.layer.cornerRadius = self.rateFrameView.frame.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - 
    //MARK: - Set Seller Rating
    func setSellerRating(rating: Int) {
        for button in self.starFrameView.subviews {
            if button.isKindOfClass(UIButton) && button.tag != 0 {
                if button.tag <= rating {
                    button.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
                    //self.starOneButton.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
                }
            }
        }
    }
    
    //MARK: - 
    //MARK: - Cancel
    @IBAction func cancel(sender: UIButton) {
        self.delegate?.feedBackTableViewCell(self, didTapCancel: sender)
    }
}
