//
//  ProductAttributeTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CartProductAttributeTableViewCellDelegate {
    func selectedAttribute(attributeId: String)
    func deselectedAttribute(attributeId: String)
}

class CartProductAttributeTableViewCell: UITableViewCell {
    
    var delegate: CartProductAttributeTableViewCellDelegate?
    
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var filter: FilterAttributeModel!
    var productAttribute: ProductAttributeModel!
    var productUnit: ProductUnitsModel!
    
    var attributeIDs: [String] = []
    var unitIDs: [String] = []
    
    var availableCombinations = [String: [String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func passModel(model: ProductAttributeModel, selectedProductUnit: ProductUnitsModel, availableCombination: [String: [String]], unitID: [String]){
        productAttribute = model
        filter = FilterAttributeModel(title: model.attributeName, attributes: model.valueName)
        productUnit = selectedProductUnit
        
        attributeIDs = productAttribute.valueId
        
        unitIDs = unitID
        initializeScrollView()
    }
    
    func initializeScrollView() {
        attributeLabel.text = filter.title
        
        var x: Int = 0
        var contentWidth = 0
        println(filter.attributes.count)
        for var i = 0; i < filter.attributes.count; i++ {
            var width = (count(filter.attributes[i]) * 10) + 20
            
            var button = UIButton(frame: CGRectMake(CGFloat(x), CGFloat(10), CGFloat(width), scrollView.frame.height/1.5))
            button.setTitle(filter.attributes[i] as String, forState: .Normal)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.layer.borderWidth = 1.2
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = button.frame.height/2
            button.backgroundColor = UIColor.whiteColor()
            button.tag = attributeIDs[i].toInt()!
            button.addTarget(self, action: "clickedAttribute:", forControlEvents: .TouchUpInside)
            
            x += width + 10
            
            if contains(productUnit.combination, attributeIDs[i]){
                SelectButton(button)
            }
            
            scrollView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(x), height: scrollView.frame.size.height)
    }
    
    
    func clickedAttribute(sender: UIButton!) {
        
        if sender.selected {
            DeselectButton(sender)
        } else {
            for view in scrollView.subviews as! [UIView]{
                if let button = view as? UIButton {
                    DeselectButton(button)
                }
            }
            SelectButton(sender)
            
            delegate?.selectedAttribute("\(sender.tag)")
        }
    }
    
    func DeselectButton(button: UIButton) {
        button.selected = false
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        
        delegate?.deselectedAttribute("\(button.tag)")
    }
    
    func SelectButton(button: UIButton) {
        button.selected = true
        button.layer.borderColor = UIColor.purpleColor().CGColor
        button.backgroundColor = UIColor.purpleColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }

    func enableButton(button: UIButton) {
        button.alpha = 1.0
        button.enabled = true
    }
    
    func disableButton(button: UIButton) {
        button.alpha = 0.3
        button.enabled = false
    }
    
}
