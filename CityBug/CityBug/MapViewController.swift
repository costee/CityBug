//
//  FirstViewController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 04..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var timer = NSTimer()


    @IBOutlet weak var mapView: MKMapView! {
        didSet {
        mapView.mapType = .Hybrid
        mapView.delegate = self
        }
    }
    
    var displayedLocations: [CLLocation] = []
    
    @IBAction func openSettings(sender: UIBarButtonItem) {
        if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        
        UINavigationBar.appearance().barTintColor = nil
        UINavigationBar.appearance().barStyle = UIBarStyle.Default
        
        SharedUserLocation.setupMapView(self)
        super.viewDidLoad()
        mapView.showsUserLocation = true
        SharedUserLocation.locationManager.startUpdatingLocation()
        
        view.backgroundColor = CBLightGray
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "moveMap", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshMap(sender: UIBarButtonItem) {
        moveMap()
    }
    
    func moveMap() {
        let spanX = 0.007
        let spanY = 0.007
        
        var newRegion = MKCoordinateRegion()
        
        if let centerLocation = displayedLocations.last?.coordinate {
            
            newRegion = MKCoordinateRegion(center: centerLocation, span: MKCoordinateSpanMake(spanX, spanY))
            mapView.setRegion(newRegion, animated: true)
            
        }
    }
    
    func addLocation(newLocation: CLLocationCoordinate2D) {
        
        let location = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
        
        displayedLocations.append(location)
        
        if SaveAssistant.sharedInstance.isRecording {
            drawLine()
        }
        
    }
    
    func drawLine() {
        
        moveMap()
        
        if (displayedLocations.count > 1) {
            let sourceIndex = displayedLocations.count - 1
            let destinationIndex = displayedLocations.count - 2
            let c1 = displayedLocations[sourceIndex].coordinate
            let c2 = displayedLocations[destinationIndex].coordinate
            var displayedPoints = [c1, c2]
            let polyline = MKPolyline(coordinates: &displayedPoints, count: displayedPoints.count)
            
            mapView.addOverlay(polyline)
        }
        
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        print("I'm drawing on the map")
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = CBRed
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }

    
    
}

