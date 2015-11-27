//
//  HomePageModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomePageModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var data: [AnyObject] = []
    
    override init() {
        
    }
    
    init(message: String, isSuccessful: Bool, data: [AnyObject]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.data = data
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> HomePageModel {
        var message: String = ""
        var isSuccessful: Bool = false
        var data: [AnyObject] = []
        
        var arrays: [NSDictionary] = []
        
        arrays = dictionary["data"] as! [NSDictionary]
        
        for arrayDictionary in arrays {
            let layoutId: Int = arrayDictionary["layoutId"] as! Int
            
            if layoutId == 1 {
                data.append(LayoutOneModel.parseDataFromDictionary(arrayDictionary))
            }
        }
        
        if let temp = dictionary["message"] as? String {
            message = temp
        }
        
        if let temp = dictionary["isSuccessful"] as? Bool {
            isSuccessful = temp
        }
        
        return HomePageModel(message: message, isSuccessful: isSuccessful, data: data)
    }
}
