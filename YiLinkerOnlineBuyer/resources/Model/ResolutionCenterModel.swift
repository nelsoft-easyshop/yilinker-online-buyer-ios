//
//  ResolutionCenterModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by @EasyShop.ph on 9/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

typealias ResolutionCenterElement = (ticketId: String, resolutionId: String, status: String, date: String, type: String, complainantRemarks: String, csrRemarks: String)

class ResolutionCenterModel {
    var message: String = ""
    var isSuccessful: Bool = false
    var resolutionArray: [ResolutionCenterElement]
    
    init(message: String, isSuccessful: Bool, resolutionArray: [ResolutionCenterElement]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.resolutionArray = resolutionArray
    }
    
    class func parseDictionaryString(dictionary: NSDictionary, key: String, defaultValue: String = "") -> String {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? String {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    class func autocorrectStatus(elementStatus: String) -> String {
        switch elementStatus {
        case "CLOSE","Close","close","CLOSED","closed":
            return "Closed"
        case "OPEN","open":
            return "Open"
        default:
            return elementStatus
        }
    }
    class func parseDictionaryBool(dictionary: NSDictionary, key: String, defaultValue: Bool = false) -> Bool {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Bool {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    class func parseDataWithDictionary(dictionary: AnyObject) -> ResolutionCenterModel {
        if dictionary.isKindOfClass(NSDictionary) {
            let aDictionary = dictionary as! NSDictionary
            let message = parseDictionaryString(aDictionary, key:"message")
            let isSuccessful = parseDictionaryBool(aDictionary, key:"isSuccessful")
            var arrayResolutionCenter = [ResolutionCenterElement]()
            
            if let dictionaryArray = dictionary["data"] as? NSArray {
                for arrayElement in dictionaryArray {
                    if let currentElement = arrayElement as? NSDictionary {
                        var element: ResolutionCenterElement
                        
                        var dates = parseDictionaryString(currentElement, key:"dateAdded")
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date: NSDate = dateFormatter.dateFromString(dates)!
                        
                        let dateFormatter1 = NSDateFormatter()
                        dateFormatter1.dateFormat = "MMMM dd, yyyy"
                        dates = dateFormatter1.stringFromDate(date)
//                        let dateAdded = dateFormatter1.stringFromDate(date)
                        
                        element.resolutionId = parseDictionaryString(currentElement, key:"disputeId")
                        element.status = parseDictionaryString(currentElement, key:"disputeStatusType")
                        element.status = autocorrectStatus( element.status )
                        element.type = parseDictionaryString(currentElement, key:"orderProductStatus")
                        element.date = dates//parseDictionaryString(currentElement, key:"dateAdded")//dateAdded
                        element.ticketId = parseDictionaryString(currentElement, key: "ticketId")
                        // unused: "disputeeFullName"
                        // unused: "disputeeContactNumber"
                        element.complainantRemarks = ""
                        element.csrRemarks = ""
                        
                        arrayResolutionCenter.append(element)
                    }
                }
            }
            
            return ResolutionCenterModel(message: message, isSuccessful: isSuccessful, resolutionArray: arrayResolutionCenter)
        } else {
            return ResolutionCenterModel(message: "", isSuccessful:false, resolutionArray: [ResolutionCenterElement]())
        }
    }
    
}