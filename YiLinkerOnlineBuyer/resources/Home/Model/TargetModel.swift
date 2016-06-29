//
//  ViewMoreModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TargetModel: NSObject {
    var targetUrl: String = ""
    var targetType: String = ""
    var isAuthenticated: Bool = false
    
    override init() {
        
    }
    
    init(targetUrl: String, targetType: String, isAuthenticated: Bool) {
        self.targetUrl = targetUrl
        self.targetType = targetType
        self.isAuthenticated = isAuthenticated
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> TargetModel {
        var targetUrl: String = ""
        var targetType: String = ""
        var isAuthenticated: Bool = false
        
        if let temp = dictionary["targetUrl"] as? String {
            targetUrl = temp
        }
        
        if let temp = dictionary["targetType"] as? String {
            targetType = temp
        }
        
        if let temp = dictionary["isAuthenticated"] as? Bool {
            isAuthenticated = temp
        }
        
        return TargetModel(targetUrl: targetUrl, targetType: targetType, isAuthenticated: isAuthenticated)
    }
}
