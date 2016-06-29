//
//  DateUtility.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class DateUtility: NSObject {
    
    static let oneDay = 60 * 60 * 24
    static let twoDays = (60 * 60 * 24) * 2
    static let sevenDays = (60 * 60 * 24) * 7
    
    static let fullFormat = "dd/MM/YYYY HH:mm a"
    static let dateFormat = "MM/dd/YYYY"
    static let hourFormat = "HH:mm"
    static let dayFormat = "EEEE"
    static let yday = "Yesterday"
    
    class func convertDateToString(tempDt : NSDate) -> NSString{
        let result = tempDt.timeIntervalSinceNow
        var intervalRaw = NSInteger(result)
        
        var interval = intervalRaw * (-1) // convert to seconds
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        //println("INTERVAL \(interval)")
        if (interval < oneDay){
            dateStringFormatter.dateFormat = hourFormat
        } else if (interval >= oneDay && interval < twoDays){
            return yday
        } else if (interval >= twoDays && interval < sevenDays){
            dateStringFormatter.dateFormat = dayFormat
        } else if (interval >= sevenDays){
            dateStringFormatter.dateFormat = dateFormat
        }
        return dateStringFormatter.stringFromDate(tempDt)
        
    }
    
    class func getTimeFromDate(tempDT : NSDate) -> NSString {
        
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        dateStringFormatter.dateFormat = fullFormat
        return dateStringFormatter.stringFromDate(tempDT)
    }
    
}
