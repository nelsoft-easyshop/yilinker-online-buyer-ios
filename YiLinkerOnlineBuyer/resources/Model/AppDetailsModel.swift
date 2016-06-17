//
//  AppDetailsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/5/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class AppDetailsModel: NSObject {
    
    var version: String = ""
    var releaseNotes: String = ""
    
    override init() {
        
    }
    
    init(version: String, releaseNotes: String) {
        self.version = version
        self.releaseNotes = releaseNotes
    }
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> AppDetailsModel {
        var version: String = ""
        var releaseNotes: String = ""
        
        if let results: NSArray = dictionary["results"] as? NSArray {
            if results.count != 0 {
                if let result: NSDictionary = results[0] as? NSDictionary {
                    if let tempVersion: String = result["version"] as? String {
                        version = tempVersion
                    }
                    
                    if let tempReleaseNotes: String = result["releaseNotes"] as? String {
                        releaseNotes = tempReleaseNotes
                    }
                }
                
            }
        }
        
        return AppDetailsModel(version: version, releaseNotes: releaseNotes)
    }
}
