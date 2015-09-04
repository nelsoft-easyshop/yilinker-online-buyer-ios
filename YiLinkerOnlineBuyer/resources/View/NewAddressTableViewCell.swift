//
//  NewAddressTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol NewAddressTableViewCellDelegate {
    func newAddressTableViewCell(didClickNext newAddressTableViewCell: NewAddressTableViewCell)
    func newAddressTableViewCell(didClickPrevious newAddressTableViewCell: NewAddressTableViewCell)
    func newAddressTableViewCell(didBeginEditing newAddressTableViewCell: NewAddressTableViewCell, index: Int)
    
    func newAddressTableViewCell(didSelectRow row: Int, cell: NewAddressTableViewCell)
}

class NewAddressTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
   
    @IBOutlet weak var rowTitleLabel: UILabel!
    @IBOutlet weak var rowTextField: UITextField!
    
    var titles: [String] = []
    
    var delegate: NewAddressTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.rowTextField.delegate = self
//      self.rowTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.newAddressTableViewCell(didBeginEditing: self, index: self.tag)
    }
    
    func addPicker(selectedIndex: Int) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        self.rowTextField.inputView = pickerView
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return titles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.titles[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.newAddressTableViewCell(didSelectRow: row, cell: self)
    }
    
//    func next() {
//        self.delegate!.newAddressTableViewCell(didClickNext: self)
//    }
//    
//    func previous() {
//        self.delegate!.newAddressTableViewCell(didClickPrevious: self)
//    }
//    
//    func done() {
//        self.endEditing(true)
//    }
    
}
