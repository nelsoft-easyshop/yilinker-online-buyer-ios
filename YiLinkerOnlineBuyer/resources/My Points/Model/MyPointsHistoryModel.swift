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
    var data: [MyPointsModel] = []
    
    init(isSuccessful: Bool, message: String, data: [MyPointsModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> MyPointsHistoryModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var data: [MyPointsModel] = []
        
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
                for subValue in dictionary["data"] as! NSArray {
                    let model: MyPointsModel = MyPointsModel.parseDataWithDictionary(subValue as! NSDictionary)
                    data.append(model)
                }
            }
        }
        
        return MyPointsHistoryModel(isSuccessful: isSuccessful, message: message, data: data)
    }
}
