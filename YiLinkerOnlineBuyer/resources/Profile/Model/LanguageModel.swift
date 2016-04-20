//
//  LanguageModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/19/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LanguageModel: NSObject {
   
    var languageId: Int = 0
    var name: String = ""
    var code: String = ""
    
    init(languageId: Int, name: String, code: String) {
        self.languageId = languageId
        self.name = name
        self.code = code
    }
    
    class func pareseDataFromResponseObject(dictionary: NSDictionary) -> LanguageModel {
        var languageId: Int = 0
        var name: String = ""
        var code: String = ""
        
        if let temp = dictionary["languageId"] as? Int {
            languageId = temp
        }
        
        if let temp = dictionary["name"] as? String {
            name = temp
        }
        
        if let temp = dictionary["code"] as? String {
            code = temp
        }
        
        return LanguageModel(languageId: languageId, name: name, code: code)
    }
    
    class func pareseArrayFromResponseObject(data: AnyObject) -> [LanguageModel] {
        var languages: [LanguageModel] = []
        
        if let tempArray = data as? NSArray {
            for obj in tempArray {
                if let temp = obj as? NSDictionary {
                    languages.append(LanguageModel.pareseDataFromResponseObject(temp))
                }
            }
        }
        
        return languages
    }
}
