//
//  UserLocation.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 11..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import MapKit

let SharedUserLocation = UserLocation()

class UserLocation: NSObject, CLLocationManagerDelegate {
    
    class var manager: UserLocation {
        return SharedUserLocation
    }
    
    var locationManager = CLLocationManager()
    
    var currentSpeed: Int {
        get {
            if let lastLocation = self.rawLocations.last {
                return abs(Int(Double(lastLocation.speed) * 3.6))
            } else {
                return 0
            }
        }
    }
    
    var mapView: MapViewController?
    
    func setupMapView(mapView: MapViewController) {
        self.mapView = mapView
    }

    
    // You can access the lat and long by calling:
    // currentLocation2d.latitude, etc
    
    var currentLocation2d:CLLocationCoordinate2D? {
        didSet {
            if let tempLocation = currentLocation2d, mapView = self.mapView {
                mapView.addLocation(tempLocation)
            }
        }
    }
    
    var rawLocations = [CLLocation]()
    
    var distance: Double = 0
    
    func reset() {
        if !(rawLocations.isEmpty) {
            rawLocations.removeAll(keepCapacity: false)
        }
        distance = 0.0
    }

    
    override init () {
        super.init()
        currentLocation2d = CLLocationCoordinate2D()
        if self.locationManager.respondsToSelector(Selector("requestAlwaysAuthorization")) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 1
        locationManager.requestWhenInUseAuthorization()
        locationManager.activityType = CLActivityType.OtherNavigation
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        if let lastLocation = rawLocations.last {
            distance += lastLocation.distanceFromLocation(location)
        }
        rawLocations.append(location)
        
        self.currentLocation2d = manager.location?.coordinate
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .AuthorizedWhenInUse:
            print("Location access OK")
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .Denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to be able to track your rides, CityBug needs access to your location.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            if let mapView = self.mapView {
                mapView.presentViewController(alertController, animated: true, completion: nil)
            }
            
        case .Restricted:
            let alertController = UIAlertController(
                title: "Location is restricted",
                message: "Contact the person who manages your Restrictions to enable location tracking for this app.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
        case .AuthorizedAlways:
            print("Impossible Location permission")
        }
        
    }

    
}