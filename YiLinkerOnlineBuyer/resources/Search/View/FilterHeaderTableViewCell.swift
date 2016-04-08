//
//  FilterHeaderTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/6/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FilterHeaderTableViewCellDelegate {
    func filterHeaderTableViewCell(filterHeaderTableViewCell: FilterHeaderTableViewCell, didTapCancel button: UIButton)
    func filterHeaderTableViewCell(filterHeaderTableViewCell: FilterHeaderTableViewCell, didTapReset button: UIButton)
    func filterHeaderTableViewCell(filterHeaderTableViewCell: FilterHeaderTableViewCell, didPriceRangeChangedMaxPrice: Double, minPrice: Double)
}

class FilterHeaderTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "FilterHeaderTableViewCell"
    
    var delegate: FilterHeaderTableViewCellDelegate?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var rangeBar: TTRangeSlider!
    
    var maxPrice: Double = 0
    var minPrice: Double = 0
    var selectedMaxPrice: Double = 0
    var selectedMinPrice: Double = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.rangeBar.delegate = self
        self.initializeLocalizedString()
    }
    
    func initializeLocalizedString() {
        let cancelLocalizeString: String = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
        self.cancelButton.setTitle(cancelLocalizeString, forState: UIControlState.Normal)
        
        let doneLocalizeString: String = StringHelper.localizedStringWithKey("RESET_LOCALIZE_KEY")
        self.resetButton.setTitle(doneLocalizeString, forState: UIControlState.Normal)
    }

    func setMinMaxValue(min: Double, max: Double) {
        self.rangeBar.minValue = Float(min)
        self.rangeBar.maxValue = Float(max)
        
        self.maxPrice = max
        self.minPrice = min
    }
    
    func setMinMaxSelectedValue(min: Double, max: Double) {
        self.rangeBar.selectedMinimum = Float(min)
        self.rangeBar.selectedMaximum = Float(max)
        
        self.selectedMaxPrice = max
        self.selectedMinPrice = min
    }
    
    @IBAction func buttonAction(sender: UIButton) {
        if sender == cancelButton {
            delegate?.filterHeaderTableViewCell(self, didTapCancel: sender)
        } else if sender == resetButton {
            delegate?.filterHeaderTableViewCell(self, didTapReset: sender)
        }
    }
    
}

extension FilterHeaderTableViewCell: TTRangeSliderDelegate {
    func rangeSlider(sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        self.selectedMaxPrice = Double(selectedMaximum)
        self.selectedMinPrice = Double(selectedMinimum)
        
        self.delegate?.filterHeaderTableViewCell(self, didPriceRangeChangedMaxPrice: self.selectedMaxPrice, minPrice: self.selectedMinPrice)
    }
}
