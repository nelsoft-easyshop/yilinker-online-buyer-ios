//
//  ProductAttributeTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductAttributeTableViewCellDelegate {
    func selectedAttribute(controller: ProductAttributeTableViewCell, attributeIndex: Int, attributeValue: String!, attributeId: Int)
    func selectedAttribute2(controller: ProductAttributeTableViewCell, currentSelected: [String])
}

class ProductAttributeTableViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var attributeLabel: UILabel!

    var scroll: UIScrollView!
    var myIndex: Int!
    var selectedAttributeIndex = 0
    var aSelected: String = ""
    
    var attributesId: [String] = []
    var attributesName: [String] = []
    var selectedId: [String] = []
    var selectedValue: [String] = []
    var selectedAttributes: [String] = []
    
    var availableCombinationString: String = ""
    
    var delegate: ProductAttributeTableViewCellDelegate?
    
    var productDetailModel: ProductDetailsModel!
    
    var scrollPosition: CGFloat = 0.0
    var buttonWidths: [CGFloat] = []
    var isEditingAttribute: Bool = true
    
    var selectedValues2: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods

    func setAttribute(model: ProductAttributeModel, availableCombination: NSArray, selectedValue: NSArray, selectedId: NSArray, width: CGFloat, currentAttributes: [String]) {
        attributeLabel.text = ProductStrings.select + " \(model.attributeName)"
        
        self.attributesId = []
        self.attributesId = model.valueId
        self.attributesName = []
        self.attributesName = model.valueName
        self.selectedAttributes = []
        self.selectedAttributes = currentAttributes

        availableCombinationString = ""
        for i in 0..<availableCombination.count {
            availableCombinationString += availableCombination[i] as! String
        }
        
        addScrollViewWithAttributes(model.choices, availableCombination: availableCombination, selectedValue: selectedValue, selectedId: selectedId, width: width, currentAttributes: self.selectedAttributes)
    }
    
    func passProductDetailModel(model: ProductDetailsModel) {
        self.productDetailModel = model
    }
    
    func addScrollViewWithAttributes(attributes: NSArray, availableCombination: NSArray, selectedValue: NSArray, selectedId: NSArray, width: CGFloat, currentAttributes: [String]) {
        
        for view in self.subviews {
            if view.isKindOfClass(UIScrollView) {
                view.removeFromSuperview()
            }
        }
        
        scroll = UIScrollView(frame: CGRectMake(0, 0, width, 200))
        scroll.delegate = self
        var spacingX: CGFloat = 0.0
        
        var topMargin: CGFloat = 25.0
        var leftMargin: CGFloat = 15.0
        var buttonWidth: CGFloat = (width / 2) - 30.0
        var buttonHeight: CGFloat = 30.0
        
        for i in 0..<attributes.count {
            // Dynamic width
//            var buttonWidth: Int = (count(buttonTitle) * 10) + 20
//            var button = UIButton(frame: CGRectMake(CGFloat(leftMargin), scroll.frame.size.height - 45/*(scroll.frame.size.height / 2) - 15*/, CGFloat(buttonWidth), 30))
            let buttonTitle: String = attributes[i] as! String
            
            if i % 2 != 0 {
                leftMargin += leftMargin + buttonWidth
            } else {
                leftMargin = 20.0
            }

            var button = UIButton(frame: CGRectMake(leftMargin, topMargin, buttonWidth, buttonHeight))
            button.setTitle(buttonTitle, forState: .Normal)
            button.titleLabel?.font = UIFont(name: "Panton-Bold", size: 15.0)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.layer.borderWidth = 1.2
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = 15
            button.backgroundColor = UIColor.whiteColor()
            button.addTarget(self, action: "clickedAttriubte:", forControlEvents: .TouchUpInside)
            button.tag = attributesId[i].toInt()!
            
            if i % 2 != 0 {
                topMargin += 40.0
            }

//            if availableCombinationString.rangeOfString(attributesId[i]) == nil {
//                self.disableButton(button)
//            }
            
            for selected in currentAttributes {
                if buttonTitle == selected {
                    SelectButton(button)
                }
            }
            
//            for a in 0..<selectedId.count {
//                if attributesId[i] == selectedId[a] as! String {
//                    button.selected = true
//                    button.layer.borderColor = Constants.Colors.appTheme.CGColor
//                    button.backgroundColor = Constants.Colors.appTheme
//                    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//                }
//            }
            
            scroll.addSubview(button)
//            scroll.contentSize = CGSize(width: scroll.frame.size.width, height: topMargin)
        }

        self.addSubview(scroll)
        self.scroll.contentOffset.x = self.scrollPosition
        
//        self.frame.size.height = 200.0
    }
    
    func formatCombination(combinations: NSArray) -> String {
        var formatCombination = ""
        
        for i in 0..<combinations.count {
            formatCombination += combinations[i] as! String
            if i != combinations.count - 1 {
                formatCombination += "_"
            }
        }
        
        return formatCombination
    }
    
    // MARK: - Actions
    
    func clickedAttriubte(sender: UIButton!) {
        
//        selectedValues2.append(sender.titleLabel.text)
        
        
        if sender.selected {
//            self.selectedAttributes[self.tag + 1] = ""
//            DeselectButton(sender)
        } else {
            self.selectedAttributes[self.tag + 1] = sender.titleLabel!.text!
            SelectButton(sender)
        }
        println(selectedAttributes)
        
        delegate?.selectedAttribute2(self, currentSelected: self.selectedAttributes)
//        if sender.selected { // Unselect
//            DeselectButton(sender)
//            if let delegate = self.delegate {
//                delegate.selectedAttribute(self, attributeIndex: self.tag, attributeValue: "", attributeId: -1)
//            }
//        } else {
//            for view in scroll.subviews as! [UIView]{
//                if let button = view as? UIButton {
//                    DeselectButton(button)
//                }
//            }
//            SelectButton(sender)
//        }
    }
    
    func DeselectButton(button: UIButton) {
        button.selected = false
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    }
    
    func SelectButton(button: UIButton) {
        button.selected = true
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.backgroundColor = Constants.Colors.appTheme
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
//        if let delegate = self.delegate {
//            delegate.selectedAttribute(self, attributeIndex: self.tag, attributeValue: button.titleLabel?.text!, attributeId: button.tag)
//        }
        
    }
    
    func enableButton(button: UIButton) {
        button.alpha = 1.0
        button.userInteractionEnabled = true
    }
    
    func disableButton(button: UIButton) {
        button.alpha = 0.3
        button.userInteractionEnabled = false
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollPosition = scrollView.contentOffset.x
    }
}
