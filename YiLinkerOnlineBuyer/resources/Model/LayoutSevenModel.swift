//
//  LayoutOneModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutSevenModel: NSObject {
    var layoutId: Int = 0
    var sectionTitle: String = ""
    var isViewMoreAvailable: Bool = false
    var viewMoreTarget: TargetModel = TargetModel()
    var data: [HomeProductModel] = []
    var remainingTime: String = ""
    
    override init() {
        
    }
    
    init(layoutId: Int, sectionTitle: String, isViewMoreAvailable: Bool, viewMoreTarget: TargetModel, remainingTime: String, data: [HomeProductModel]) {
        self.layoutId = layoutId
        self.sectionTitle = sectionTitle
        self.isViewMoreAvailable = isViewMoreAvailable
        self.viewMoreTarget = viewMoreTarget
        self.data = data
        self.remainingTime = remainingTime
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> LayoutSevenModel {
        var layoutId: Int = 0
        var sectionTitle: String = ""
        var isViewMoreAvailable: Bool = false
        var viewMoreTarget: TargetModel = TargetModel()
        var remainingTime: String = ""
        var data: [HomeProductModel] = []
        
        if let temp = dictionary["layoutId"] as? Int {
            layoutId = temp
        }
        
        if let temp = dictionary["sectionTitle"] as? String {
            sectionTitle = temp
        }
        
        if let temp = dictionary["isViewMoreAvailable"] as? Bool {
            isViewMoreAvailable = temp
        }
        
        if let temp = dictionary["viewMoreTarget"] as? NSDictionary {
            viewMoreTarget = TargetModel.parseDataFromDictionary(temp)
        }
        
        if let temps = dictionary["data"] as? [NSDictionary] {
            for temp in temps {
                data.append(HomeProductModel.parseDataFromDictionary(temp))
            }
        }
        
        if let temp = dictionary["remainingTime"] as? String {
            remainingTime = temp
        }
        
        return LayoutSevenModel(layoutId: layoutId, sectionTitle: sectionTitle, isViewMoreAvailable: isViewMoreAvailable, viewMoreTarget: viewMoreTarget, remainingTime: remainingTime, data: data)
    }
}
