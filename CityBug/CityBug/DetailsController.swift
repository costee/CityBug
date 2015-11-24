//
//  DetailsController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 18..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit
import MapKit

class DetailsController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    var route: Route!

    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxSpeed: UILabel!
    @IBOutlet weak var avgSpeed: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    var routeImageViewFrame = CGRect()
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .Hybrid
            mapView.delegate = self
        }
    }
    
    @IBAction func shareRoute(sender: UIBarButtonItem) {
        
        let roundedDistance = round(route.distance * 100) / 100
        let textToShare = "I just traveled \(roundedDistance) kms with my CityBug!"
        
        if let image = SaveAssistant.sharedInstance.loadImage(route)
        {
            let objectsToShare = [textToShare, image]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAddToReadingList, UIActivityTypePrint, UIActivityTypeAssignToContact]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    func growImage() {
        //Grow
        if self.routeImage.frame != self.view.bounds {
            self.routeImageViewFrame = self.routeImage.frame
            self.blurView.frame = self.view.bounds
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.1, options: [], animations: { () -> Void in
                self.routeImage.frame = self.view.bounds
                self.routeImage.contentMode = UIViewContentMode.ScaleAspectFit
                self.blurView.alpha = 1.0
        }, completion: nil)
        } else { //SHRINK
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.7, options: [], animations: { () -> Void in
                self.routeImage.frame = self.routeImageViewFrame
                }, completion: nil)
            self.blurView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            
        }
    }
    
    func moveMap() {
        let spanX = 0.007
        let spanY = 0.007
        
        var newRegion = MKCoordinateRegion()
        
        if let centerLocation = route.routeLocations.firstObject() as? RouteLocation {
            
            let centerPoint = centerLocation.getLocationForDrawing()
            
            newRegion = MKCoordinateRegion(center: centerPoint, span: MKCoordinateSpanMake(spanX, spanY))
            mapView.setRegion(newRegion, animated: true)
            
        }
    }
    
    func zoomToPolyLine(polyline: MKPolyline, animated: Bool) {
        mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: animated)
    }
    
    func drawLine() {
        
        if (route.routeLocations.count > 1) {
            var displayedPoints = [CLLocationCoordinate2D]()
            for var index:UInt = 0; index < (route.routeLocations.count); index++ {
                let location = (route.routeLocations.objectAtIndex(index) as! RouteLocation).getLocationForDrawing()
                displayedPoints.append(location)
            }
            let polyline = MKPolyline(coordinates: &displayedPoints, count: displayedPoints.count)
            
            zoomToPolyLine(polyline, animated: true)
            
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

    
    override func viewDidLoad() {
        self.navigationItem.title = route.title
        if let image = SaveAssistant.sharedInstance.loadImage(route) {
            routeImage.bounds = CGRect(x: 0, y: 0, width: 84, height: 84)
            routeImage.image = image
            routeImage.contentMode = UIViewContentMode.ScaleAspectFit
        }
        
        //routeImage.autoresizingMask = UIViewAutoresizing.None
        routeImage.clipsToBounds = true
        
        let tapImage:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("growImage"))
        tapImage.numberOfTapsRequired = 1
        routeImage.addGestureRecognizer(tapImage)
        
        blurView.alpha = 0.0
        
        let multiplier = 100.0 //2 decimal accuracy
        
        //loading texts
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.text = route.formattedStart(true)
        let roundedMax = round(route.maxSpeed * multiplier) / multiplier
        maxSpeed.text = "\(roundedMax) km/h"
        //let roundedAvg = round(route.averageSpeed * multiplier) / multiplier
        avgSpeed.text = "\(round(route.averageSpeed)) km/h"
        let roundedDistance = round(route.distance * multiplier) / multiplier
        distanceLabel.text = "\(roundedDistance) km"
        
        drawLine()
        
        super.viewDidLoad()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
