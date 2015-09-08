//
//  ActivityLogModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogModel: NSObject {
    var text: String = ""
    var activities: [ActivityModel] = []
    
    init(text: String, activities: [ActivityModel]) {
        self.text = text
        self.activities = activities
    }
    
    init(activities: [ActivityModel]) {
        self.activities = activities
    }
    
    class func parsaDataFromDictionary(dictionary: AnyObject) -> ActivityLogModel! {
        var date: String = ""
        var activitiesModel: [ActivityModel] = [ActivityModel]()
         if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                if let val: AnyObject = value["activities"] {
                   
                    let activitiesArray: NSArray = value["activities"] as! NSArray
                    
                    for activityDictionary in activitiesArray as! [NSDictionary] {
                        let activityModel: ActivityModel = ActivityModel.parsaDataFromDictionary(activityDictionary)
                        activitiesModel.append(activityModel)
                    }
                }
            }
        }
        
        let activityLogsModel = ActivityLogModel(activities: activitiesModel)
        return activityLogsModel

    }
}
