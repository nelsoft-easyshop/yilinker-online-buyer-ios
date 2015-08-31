//
//  SearchSuggestionModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchSuggestionModel: NSObject {
   
    var suggestion: String = ""
    var imageURL: String = ""
    var searchUrl: String = ""
    
    init(suggestion: String, imageURL: String, searchUrl: String) {
        self.suggestion = suggestion
        self.imageURL = imageURL
        self.searchUrl = searchUrl
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> SearchSuggestionModel {
        var suggestion: String = ""
        var imageURL: String = "SearchBrowseCategory"
        var searchUrl: String = ""
        
        
        if let tempVar = dictionary["keyword"] as? String {
            suggestion = tempVar
        }
        
        if let tempVar = dictionary["searchUrl"] as? String {
            searchUrl = tempVar
        }
        
        return SearchSuggestionModel(suggestion: suggestion, imageURL: imageURL, searchUrl: searchUrl)
    }
}
