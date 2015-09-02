//
//  Wishlist.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/2/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation
import CoreData

@objc(Wishlist)
class Wishlist: NSManagedObject {

    @NSManaged var item: String
    @NSManaged var productId: Int32

}
