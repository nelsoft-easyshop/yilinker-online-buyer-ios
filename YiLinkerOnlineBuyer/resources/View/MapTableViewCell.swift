//
//  MapTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var lat: Double = 0.0
    var long: Double = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mapView.delegate = self
//        setLocation(latitude: 14.4880779641213, longitude: 121.029669824614)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    func setLocation(#latitude: Double, longitude: Double) {
        var newRegion = MKCoordinateRegion()
        newRegion.center.latitude = latitude
        newRegion.center.longitude = longitude
        newRegion.span.latitudeDelta = 0.000388
        newRegion.span.longitudeDelta = 0.006243
        
        self.mapView.setRegion(newRegion, animated: true)
    }
}
