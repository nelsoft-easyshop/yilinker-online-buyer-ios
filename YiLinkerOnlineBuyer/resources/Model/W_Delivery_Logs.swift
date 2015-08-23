//
//  W_Delivery_Logs.swift
//  Messaging
//
//  Created by Dennis Nora on 8/21/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class W_Delivery_Logs: NSObject {
    
    var status : String
    var status_time : String
    var status_date : String
    var status_location : String
    var status_rider : String
    var status_signature : String
    
    init(status : String, status_time : String, status_date : String, status_location: String, status_rider : String, status_signature : String)
    {
        self.status = status
        self.status_time = status_time
        self.status_date = status_date
        self.status_location = status_location
        self.status_rider = status_rider
        self.status_signature = status_signature
    }
    
    override init ()
    {
        self.status = ""
        self.status_time = ""
        self.status_date = ""
        self.status_location = ""
        self.status_rider = ""
        self.status_signature = ""
    }
    
    func testData() -> Array<W_Delivery_Logs> {
        return [
            W_Delivery_Logs(status: "Pickup Product", status_time: "2:58 AM", status_date: "June 23, 2014", status_location: "Gabriela Silang, Makati City Hall", status_rider: "Apo Ni Lario Mabini", status_signature: "N/A"),
            W_Delivery_Logs(status: "Warehouse Check-in", status_time: "12:32 AM", status_date: "June 24, 2014", status_location: "Warehouse A, Taguig", status_rider: "Janvan the DS Boy", status_signature: "N/A"),
            W_Delivery_Logs(status: "In Transit", status_time: "3:20 AM", status_date: "June 24, 2014", status_location: "In transit to Bogz Borja, High Street, Taguig City", status_rider: "Farly A.K.A. Puppy", status_signature: "N/A"),
            W_Delivery_Logs(status: "Delivery Complete", status_time: "4:20 AM", status_date: "June 24, 2014", status_location: "Delivered to Bogz Borja, High Street, Taguig City", status_rider: "Farly A.K.A. Puppy", status_signature: "N/A")
        ]
    }

    
}
