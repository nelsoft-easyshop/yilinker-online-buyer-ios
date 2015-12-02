//
//  LayoutEightModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 12/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LayoutEightModel: NSObject {
    var layoutId: Int = 0
    var sectionTitle: String = ""
    var isViewMoreAvailable: Bool = false
    var viewMoreTarget: TargetModel = TargetModel()
    var data: [HomeSellerModel] = []
    
    override init() {
        
    }
    
    init(layoutId: Int, sectionTitle: String, isViewMoreAvailable: Bool, viewMoreTarget: TargetModel, data: [HomeSellerModel]) {
        self.layoutId = layoutId
        self.sectionTitle = sectionTitle
        self.isViewMoreAvailable = isViewMoreAvailable
        self.viewMoreTarget = viewMoreTarget
        self.data = data
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> LayoutEightModel {
        
        var layoutId: Int = 0
        var sectionTitle: String = ""
        var isViewMoreAvailable: Bool = false
        var viewMoreTarget: TargetModel = TargetModel()
        var data: [HomeSellerModel] = []
        
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
        
        if let dictionaries = dictionary["data"] as? [NSDictionary] {
            for tempDictionary in dictionaries {
                data.append(HomeSellerModel.parseDataFromDictionary(tempDictionary))
            }
        }
        
        return LayoutEightModel(layoutId: layoutId, sectionTitle: sectionTitle, isViewMoreAvailable: isViewMoreAvailable, viewMoreTarget: viewMoreTarget, data: data)
    }
}
