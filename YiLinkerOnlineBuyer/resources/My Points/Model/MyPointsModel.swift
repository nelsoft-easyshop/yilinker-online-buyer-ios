//
//  MyPointsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class MyPointsModel: NSObject {
   
    var userPointHistoryId: Int = 0
    var points: String = ""
    var date: String = ""
    var userId: Int = 0
    var userPointTypeId: Int = 0
    var userPointTypeName: String = ""

    init(userPointHistoryId: Int, points: String, date: String, userId: Int, userPointTypeId: Int, userPointTypeName: String) {
        self.userPointHistoryId = userPointHistoryId
        self.points = points
        self.date = date
        self.userId = userId
        self.userPointTypeId = userPointTypeId
        self.userPointTypeName = userPointTypeName
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> MyPointsModel {
        
        var userPointHistoryId: Int = 0
        var points: String = ""
        var date: String = ""
        var userId: Int = 0
        var userPointTypeId: Int = 0
        var userPointTypeName: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["userPointHistoryId"] != nil {
                if let tempVar = dictionary["userPointHistoryId"] as? Int {
                    userPointHistoryId = tempVar
                }
            }
            
            if dictionary["points"] != nil {
                if let tempVar = dictionary["points"] as? String {
                    points = tempVar
                }
            }
            
            if dictionary["dateAdded"] != nil {
                let tempDict: NSDictionary = dictionary["dateAdded"] as! NSDictionary
                if let tempVar = tempDict["date"] as? String {
                    date = tempVar
                }
            }
            
            if dictionary["userId"] != nil {
                if let tempVar = dictionary["userId"] as? Int {
                    userId = tempVar
                }
            }
            
            if dictionary["userPointTypeId"] != nil {
                if let tempVar = dictionary["userPointTypeId"] as? Int {
                    userPointTypeId = tempVar
                }
            }
            
            if dictionary["userPointTypeName"] != nil {
                if let tempVar = dictionary["userPointTypeName"] as? String {
                    userPointTypeName = tempVar
                }
            }
        }
        
        return MyPointsModel(userPointHistoryId: userPointHistoryId, points: points, date: date, userId: userId, userPointTypeId: userPointTypeId, userPointTypeName: userPointTypeName)
    }
    
}
