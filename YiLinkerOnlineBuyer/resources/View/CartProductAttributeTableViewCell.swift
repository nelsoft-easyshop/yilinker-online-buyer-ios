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
    
    var attributeIDs: [String] = []
    var selectedAttributes: [String] = []
    var unitIDs: [String] = []
    var selectedAttributeID: String = ""
    var selectedAttributeIDIndex: Int = 0
    
    var availableCombinations = [String: [String]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func passModel(model: ProductAttributeModel, availableCombination: [String: [String]], unitID: [String], selectedAttributes: [String]){
        productAttribute = model
        filter = FilterAttributeModel(title: model.attributeName, selectedIndex: 0, attributes: model.valueName)
        
        attributeIDs = productAttribute.valueId
        
        availableCombinations = availableCombination
        
        unitIDs = unitID
        self.selectedAttributes = selectedAttributes
        
        for var i = 0; i < selectedAttributes.count; i++ {
            
            for var j = 0; j < attributeIDs.count; j++ {
                if selectedAttributes[i] == attributeIDs[j] {
                    selectedAttributeIDIndex = j
                }
            }
        }
        
        initializeScrollView()
    }
    
    func initializeScrollView() {
        attributeLabel.text = filter.title
        
        var x: Int = 0
        var contentWidth = 0
        println(filter.attributes.count)
        
        let subviews = self.scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
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
            
            if contains(selectedAttributes, attributeIDs[i]){
                SelectButton(button)
                enableButton(button)
            } else {
                var tempSelectedAttributes = selectedAttributes
                println("Original selected \(tempSelectedAttributes)")
                if selectedAttributes.count == 0 {
                    enableButton(button)
                } else {
                    if selectedAttributes.count < 2 {
                        tempSelectedAttributes.append(attributeIDs[i])
                    } else {
                        //tempSelectedAttributes[selectedAttributeIDIndex] = attributeIDs[i]
                        tempSelectedAttributes.append(attributeIDs[i])
                    }
                    println("Combination count \(availableCombinations.count)")
                    println("unitIDs \(unitIDs)")
                    for var j = 0; j < availableCombinations.count; j++ {
                        println("unitIDs \(unitIDs[j])")
                        println("Available \(availableCombinations[unitIDs[j]])")
                        println("Selected \(tempSelectedAttributes)")
                        if sorted(tempSelectedAttributes, <) == sorted(availableCombinations[unitIDs[j]]!, <) {
                            println("Found \(tempSelectedAttributes)")
                            enableButton(button)
                            break
                        } else {
                            disableButton(button)
                            println("Disabled \(attributeIDs[i])")
                        }
                    }
                }
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
        button.userInteractionEnabled = true
    }
    
    func disableButton(button: UIButton) {
        button.alpha = 0.25
        button.userInteractionEnabled = false
    }
    
}
