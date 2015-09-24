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
    var date: String = ""
    var activities: [ActivityModel] = []
    var all_date_section_array: [String] = []
    var date_section_array: [String] = []
    var date_array: [String] = []
    var text_array: [String] = []
    
    init(text: String, activities: [ActivityModel]) {
        self.text = text
        self.activities = activities
    }
    
    init(activities: [ActivityModel]) {
        self.activities = activities
    }
    
    init(date: String, text: String) {
        self.date = date
        self.text = text
    }
    
    init(date: NSArray, details: NSArray, date_section: NSArray, all_date_section: NSArray) {
        self.date_array = date as! [String]
        self.text_array = details as! [String]
        self.date_section_array = date_section as! [String]
        self.all_date_section_array = all_date_section as! [String]
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

    class func parsaActivityLogsDataFromDictionary(dictionary: AnyObject) -> ActivityLogModel! {
        
        var time: String = ""
        var details: String = ""
        var date_array: [String] = []
        var text_array: [String] = []
        var section_date_array: [String] = []
        var section_date_array2: [String] = []
        var all_section_date_array: [String] = []
        let dateComponents = NSDateComponents()

        if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                if let val: AnyObject = value["activities"] {
                    let activitiesArray: NSArray = value["activities"] as! NSArray
                    for activityDictionary in activitiesArray as! [NSDictionary] {
                        if activityDictionary.isKindOfClass(NSDictionary){
                            let date: NSDictionary = activityDictionary["date"] as! NSDictionary
                            if let value = date["date"] as? String {
                                //time = value
                                /*
                                var dates = value as NSString!
                                //dateComponents.year = dates.substringWithRange(NSRange(location: 0, length: 4)).toInt()!
                                //dateComponents.month = dates.substringWithRange(NSRange(location: 5, length: 2)).toInt()!
                                // dateComponents.day = dates.substringWithRange(NSRange(location: 8, length: 2)).toInt()!
                                dateComponents.hour = dates.substringWithRange(NSRange(location: 11, length: 2)).toInt()!
                                dateComponents.minute = dates.substringWithRange(NSRange(location: 14, length: 2)).toInt()!
                                //dateComponents.second = dates.substringWithRange(NSRange(location: 17, length: 2)).toInt()!
                                let formatter = NSDateFormatter()
                                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                                formatter.timeStyle = .MediumStyle
                                let date = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
                                let dateString = formatter.stringFromDate(date)
                                var trimDate = dateString.stringByReplacingOccurrencesOfString("January 1, 1 at ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                               // date_array.append(trimDate.stringByReplacingOccurrencesOfString(":00", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
                                */
                                date_array.append(value)
                                
                            }
                            
                            if let value = date["date"] as? String {
                            
                                let dateComponents = NSDateComponents()
                                
                                var dates = value as NSString!
                                var s_date = dates.substringWithRange(NSRange(location: 0, length: 15))
                                dateComponents.year = dates.substringWithRange(NSRange(location: 0, length: 4)).toInt()!
                                dateComponents.month = dates.substringWithRange(NSRange(location: 5, length: 2)).toInt()!
                                dateComponents.day = dates.substringWithRange(NSRange(location: 8, length: 2)).toInt()!
                                //dateComponents.hour = dates.substringWithRange(NSRange(location: 11, length: 2)).toInt()!
                                //dateComponents.minute = dates.substringWithRange(NSRange(location: 14, length: 2)).toInt()!
                                //dateComponents.second = dates.substringWithRange(NSRange(location: 17, length: 2)).toInt()!
                                let formatter = NSDateFormatter()
                                formatter.dateStyle = NSDateFormatterStyle.LongStyle
                                formatter.timeStyle = .MediumStyle
                                let date = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
                                let dateString = formatter.stringFromDate(date)
                                var trimDate = dateString.stringByReplacingOccurrencesOfString(" at 12:00:00 AM", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                              
                                if !contains(section_date_array2, trimDate) {
                                    //section_date_array.append(trimDate)
                                    section_date_array2.append(trimDate)
                                    section_date_array.append(value)
                                }
                                
                                //all_section_date_array.append(trimDate)
                                all_section_date_array.append(value)
                            }
                            
                            if let text = activityDictionary["text"] as? String {
                                //details = text
                                text_array.append(text)
                            }
                        }
                    }
                }
            }
        }

        let activityModel = ActivityLogModel(date: date_array, details: text_array, date_section: section_date_array, all_date_section: all_section_date_array)
    
        return activityModel
    
    }

    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func formatDateToString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToTimeString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "KK:mm aa"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToCompleteString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.stringFromDate(date)
    }
}