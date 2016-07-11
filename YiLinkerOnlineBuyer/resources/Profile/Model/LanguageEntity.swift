//
//  LanguageEntity.swift
//  
//
//  Created by John Paul Chan on 4/21/16.
//
//

import Foundation
import CoreData

@objc(LanguageEntity)
class LanguageEntity: NSManagedObject {

    @NSManaged var dateUpdated: NSDate
    @NSManaged var json: String

}
