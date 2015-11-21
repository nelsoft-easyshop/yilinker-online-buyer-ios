
//
//  UserMapView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import MapKit

class UserMapView: UIView, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var lat: Double = 0.0
    var long: Double = 0.0
    
    override func awakeFromNib() {
        
        self.mapView.delegate = self
    }
    
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.lat = mapView.centerCoordinate.latitude
        self.long = mapView.centerCoordinate.longitude
    }
    
    func latitude() -> Double {
        return self.lat
    }
    
    func longitude() -> Double {
        return self.long
    }
    
}


