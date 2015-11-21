//
//  MapViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customizedNavigationBar()
        mapView.delegate = self
        
    }

    func customizedNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-white"), style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func backAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Map View Delegate
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
//        mapView.removeAnnotations( mapView.annotations.filter { $0 !== self.mapView.userLocation } )
//        let centerLocation = MKPointAnnotation()
//        centerLocation.coordinate = mapView.centerCoordinate
//        mapView.addAnnotation(centerLocation)
//        centerLocation.title = "Map's center"
        print(mapView.centerCoordinate)
    }

}
