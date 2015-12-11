//
//  MapTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapTableViewCellDelegate {
    func showAlertForLocation()
}

class MapTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pinImageView: UIImageView!
    var lat: Double = 0.0
    var long: Double = 0.0
    var isAlreadySetLocation: Bool = false
    var currentLocation = CLLocationCoordinate2D()
    var delegate: MapTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mapView.delegate = self
//        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Map View Delegate
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        self.lat = mapView.centerCoordinate.latitude
        self.long = mapView.centerCoordinate.longitude
    }
    
    // MARK: - Location Delegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if CLLocationManager .authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startUpdatingLocation()
            self.pinImageView.hidden = false
        } else if CLLocationManager .authorizationStatus() == CLAuthorizationStatus.Denied {
            self.pinImageView.hidden = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        if !isAlreadySetLocation {
            currentLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
            isAlreadySetLocation = true
            if self.lat == 0.0 && self.long == 0.0 {
                setLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            }
        }
    }
    
    // MARK: - Methods
    
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
    
    @IBAction func gotoCurrentLocation(sender: AnyObject) {
        if self.pinImageView.hidden {
            delegate?.showAlertForLocation()
        } else {
            setLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        }
    }
}
