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
    
    init(suggestion: String, imageURL: String) {
        self.suggestion = suggestion
        self.imageURL = imageURL
    }
}
