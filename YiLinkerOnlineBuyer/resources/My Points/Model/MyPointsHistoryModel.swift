//
//  MyPointsHistoryModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class MyPointsHistoryModel: NSObject {
    var isSuccessful: Bool = false
    var message: String = ""
    var data: [PointModel] = []
    
    init(isSuccessful: Bool, message: String, data: [PointModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> MyPointsHistoryModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var data: [PointModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if dictionary["data"] != nil {
                if let tempDict = dictionary["data"] as? NSArray {
                    if tempDict.count != 0 {
                        if tempDict[0]["points"]  != nil {
                            for subValue in tempDict[0]["points"] as! NSArray {
                                let model: PointModel = PointModel.parseDataWithDictionary(subValue as! NSDictionary)
                                data.append(model)
                            }
                        }
                    }
                }
            }
        }
        
        return MyPointsHistoryModel(isSuccessful: isSuccessful, message: message, data: data)
    }
}
