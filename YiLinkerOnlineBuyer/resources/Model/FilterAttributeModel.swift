//
//  FilterAttributeModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FilterAttributeModel: NSObject {
    var title: String = ""
    var selectedIndex: Int = 0
    var attributes: [String] = []
    
    init(title: String, selectedIndex: Int, attributes: [String]) {
        self.title = title
        self.selectedIndex = selectedIndex
        self.attributes = attributes
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> FilterAttributeModel {
        var title: String = ""
        var selectedIndex: Int = 0
        var attributes: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["filterName"] as? String {
                title = tempVar
            }
            
            attributes.append("All")
            if let tempArr = dictionary["filterItems"] as? NSArray {
                for subValue in tempArr {
                    attributes.append(subValue as! String)
                }
            }
        }
        
        return FilterAttributeModel(title: title, selectedIndex: selectedIndex, attributes: attributes)
    }
}
