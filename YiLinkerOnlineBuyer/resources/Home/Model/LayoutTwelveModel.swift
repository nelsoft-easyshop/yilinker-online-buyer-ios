//
//  LayoutTwelveModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 7/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutTwelveModel: NSObject {
    var layoutId: Int = 0
    var sectionTitle: String = ""
    var isViewMoreAvailable: Bool = false
    var viewMoreTarget: TargetModel = TargetModel()
    var data: [HomeProductModel] = []
    
    override init() {
        
    }
    
    init(layoutId: Int, sectionTitle: String, isViewMoreAvailable: Bool, viewMoreTarget: TargetModel, data: [HomeProductModel]) {
        self.layoutId = layoutId
        self.sectionTitle = sectionTitle
        self.isViewMoreAvailable = isViewMoreAvailable
        self.viewMoreTarget = viewMoreTarget
        self.data = data
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> LayoutTwelveModel {
        var layoutId: Int = 0
        var sectionTitle: String = ""
        var isViewMoreAvailable: Bool = false
        var viewMoreTarget: TargetModel = TargetModel()
        var remainingTime: String = ""
        var data: [HomeProductModel] = []
        
        if let temp = dictionary["layoutId"] as? Int {
            layoutId = 12
        }
        
        if let temp = dictionary["sectionTitle"] as? String {
            sectionTitle = "Promo Sample"
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
        
        return LayoutTwelveModel(layoutId: layoutId, sectionTitle: sectionTitle, isViewMoreAvailable: isViewMoreAvailable, viewMoreTarget: viewMoreTarget, data: data)
    }
}
