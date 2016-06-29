//
//  PushNotificationModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 3/9/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PushNotificationModel: NSObject {
    var alert: String = ""
    var badge: Int = 0
    var isAuthenticated: Bool = false
    var message: String = ""
    var sound: String = ""
    var target: String = ""
    var targetType: String = ""
    var title: String = ""
    
    init(alert: String, badge: Int, isAuthenticated: Bool, message: String, sound: String, target: String, targetType: String, title: String) {
        self.alert = alert
        self.badge = badge
        self.isAuthenticated = isAuthenticated
        self.message = message
        self.sound = sound
        self.target = target
        self.targetType = targetType
        self.title = title
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> PushNotificationModel {
        var alert: String = ""
        var badge: Int = 0
        var isAuthenticated: Bool = false
        var message: String = ""
        var sound: String = ""
        var target: String = ""
        var targetType: String = ""
        var title: String = ""
        
        if let temp = dictionary["alert"] as? String {
            alert = temp
        }
        
        if let temp = dictionary["badge"] as? Int {
            badge = temp
        }
        
        if let temp = dictionary["isAuthenticated"] as? Bool {
            isAuthenticated = temp
        }
        
        if let temp = dictionary["message"] as? String {
            message = temp
        }
        
        if let temp = dictionary["sound"] as? String {
            sound = temp
        }
        
        if let temp = dictionary["target"] as? String {
            target = temp
        }
        
        if let temp = dictionary["targetType"] as? String {
            targetType = temp
        }
        
        if let temp = dictionary["title"] as? String {
            title = temp
        }
        
        return PushNotificationModel(alert: alert, badge: badge, isAuthenticated: isAuthenticated, message: message, sound: sound, target: target, targetType: targetType, title: title)
    }
}
