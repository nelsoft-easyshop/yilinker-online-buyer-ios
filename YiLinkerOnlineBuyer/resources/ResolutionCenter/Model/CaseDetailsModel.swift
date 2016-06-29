//
//  CaseDetailsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 9/17/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import Foundation

typealias RemarkElement =
    ( isAdmin: Bool
    , dateAdded: String
    , message: String
    , author: String )

typealias CaseDetailsData =
    ( ticket: String
    , statusType: String
    , orderStatus: String
    , dateAdded: String
    , dateModified: String
    , disputerName: String
    , disputeeName: String
    , description: String
    , remarks: [RemarkElement]
    , products: [String] )

let blankCaseDetails = CaseDetailsData("","","","","","","","",[RemarkElement](),[String]())

class CaseDetailsModel {
    let message: String
    let isSuccessful: Bool
    let caseData: CaseDetailsData
    
    init(message: String, isSuccessful: Bool, caseData: CaseDetailsData) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.caseData = caseData
    }
    
    class func parseDictionaryString(dictionary: NSDictionary, key: String, defaultValue: String = "") -> String {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? String {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    class func parseDictionaryBool(dictionary: NSDictionary, key: String, defaultValue: Bool = false) -> Bool {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Bool {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    class func parseDictionaryInt(dictionary: NSDictionary, key: String, defaultValue: Int = 0) -> Int {
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Int {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    class func parseDataWithDictionary(dictionary: AnyObject) -> CaseDetailsModel {
        if dictionary.isKindOfClass(NSDictionary) {
            let aDictionary = dictionary as! NSDictionary
            let message = parseDictionaryString(aDictionary, key:"message")
            let isSuccessful = parseDictionaryBool(aDictionary, key:"isSuccessful")
            var thisCase = blankCaseDetails
            
            if let dictionaryData = dictionary["data"] as? NSDictionary {
                thisCase.ticket = parseDictionaryString(dictionaryData, key:"ticket")
                thisCase.statusType = parseDictionaryString(dictionaryData, key:"disputeStatusType")
                thisCase.orderStatus = parseDictionaryString(dictionaryData, key:"orderProductStatus")
                thisCase.dateAdded = parseDictionaryString(dictionaryData, key:"dateAdded")
                thisCase.dateModified = parseDictionaryString(dictionaryData, key:"lastModifiedDate")
                thisCase.disputeeName = parseDictionaryString(dictionaryData, key:"disputerFullName")
                thisCase.disputerName = parseDictionaryString(dictionaryData, key:"disputeeFullName")
                thisCase.description = parseDictionaryString(dictionaryData, key:"description")
                
                if let remarksArray = dictionaryData["remarks"] as? NSArray {
                    thisCase.remarks = [RemarkElement]()
                    for arrayElement in remarksArray {
                        if let currentElement = arrayElement as? NSDictionary {
                            var element: RemarkElement
                            
                            let isAdminInteger = parseDictionaryInt(currentElement, key:"isAdmin")
                            element.isAdmin = (isAdminInteger != 0) ? true : false
                            element.dateAdded = parseDictionaryString(currentElement, key:"dateAdded")
                            element.message = parseDictionaryString(currentElement, key:"message")
                            element.author = parseDictionaryString(currentElement, key:"authorFullName")
                            
                            thisCase.remarks.append(element)
                        }
                    }
                }
                
                if let productsArray = dictionaryData["products"] as? NSArray {
                    thisCase.products = [String]()
                    for arrayElement in productsArray {
                        if let currentElement = arrayElement as? NSDictionary {
                            var productName: String
                            productName = parseDictionaryString(currentElement, key:"productName")
                            thisCase.products.append(productName)
                        }
                    }
                }
                
            }
            
            return CaseDetailsModel(message: message, isSuccessful: isSuccessful, caseData: thisCase)
        } else {
            return CaseDetailsModel(message: "", isSuccessful:false, caseData: blankCaseDetails)
        }
    }}