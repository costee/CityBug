//
//  SecondViewController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 04..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit
import CoreLocation
import MediaPlayer

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var speedBackgroundView: UIView!
    @IBOutlet weak var distanceBackgroundView: UIView!
    @IBOutlet weak var batteryBackgroundView: UIView!
    
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    
    @IBOutlet weak var speedometer: UIImageView!
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var batteryImage: UIImageView!
    @IBOutlet weak var batteryLabel: UILabel!
    
    @IBOutlet weak var traveledDistance: UILabel!
    @IBOutlet weak var remainingDistance: UILabel!
    @IBOutlet weak var traveledTime: UILabel!
    @IBOutlet weak var remainingTime: UILabel!
    
    
    var timer: NSTimer = NSTimer()
    
    enum LeftButtonState {
        case Connect
        case Discard
    }
    
    
    var leftButtonState: LeftButtonState = .Connect
    
    var volume: Float = 1.0
    
    @IBAction func startRoute(sender: UIBarButtonItem) {
        
        SaveAssistant.sharedInstance.isRecording = true
        
        leftButton.image = nil
        leftButton.title = "Discard Route"
        leftButton.tintColor = CBRed
        leftButtonState = .Discard
        
        rightButton.title = "Save Route"
        rightButton.tintColor = CBGreen
        rightButton.action = Selector("saveRoute:")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            SharedUserLocation.reset()
            while(SaveAssistant.sharedInstance.isRecording) {
                SaveAssistant.sharedInstance.tempRoutes = SharedUserLocation.rawLocations
            }
        })
    }
    
    @IBAction func leftButtonAction(sender: UIBarButtonItem) {
        switch (leftButtonState) {
        case .Connect: connect()
        case .Discard: discardRoute()
        }
        
    }
    
    func connect() {
        
        let connectView = self.storyboard?.instantiateViewControllerWithIdentifier("Connect") as! ConnectViewController
        self.navigationController?.pushViewController(connectView, animated:true)
        
    }
    
    func saveRoute(sender: UIBarButtonItem) {
        
        SaveAssistant.sharedInstance.isRecording = false
        
        resetButtonState()
        
        let saveRouteView = self.storyboard?.instantiateViewControllerWithIdentifier("SaveRoute") as! SaveRouteViewController
        self.navigationController?.pushViewController(saveRouteView, animated:true)
        
    }
    
    func resetButtonState() {
        
        leftButton.image = UIImage(named: "Connect")
        leftButton.title = nil
        leftButton.tintColor = CBBlue
        
        rightButton.title = "Start Route"
        rightButton.tintColor = CBBlue
        rightButton.action = Selector("startRoute:")
    }
    
    func discardRoute() {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Discard Route", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
            SaveAssistant.sharedInstance.isRecording = false
            SharedUserLocation.reset()
            self.resetButtonState()
            self.leftButtonState = .Connect
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        if let subview = alert.view.subviews.first, alertContentView = subview.subviews.first, cancelContentView = subview.subviews.last {
            for contentview in [alertContentView,cancelContentView] {
                contentview.backgroundColor = CBDarkGray
                contentview.tintColor = UIColor.whiteColor()
                contentview.layer.cornerRadius = 5
            }
        }
        
        let alertTitle: NSMutableAttributedString = NSMutableAttributedString(string: "Are you sure you want to discard the recorded route?")
        alertTitle.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(20.0), range: NSMakeRange(0,alertTitle.length))
        alertTitle.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSMakeRange(0,alertTitle.length))
        alert.setValue(alertTitle, forKey: "attributedTitle")
        
        let alertMessage: NSMutableAttributedString = NSMutableAttributedString(string: "All recorded data will be lost.")
        alertMessage.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16.0), range: NSMakeRange(0,alertMessage.length))
        alertMessage.addAttribute(NSForegroundColorAttributeName, value: CBLightGray, range: NSMakeRange(0,alertMessage.length))
        alert.setValue(alertMessage, forKey: "attributedMessage")
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func timedUpdate() {
        speedLabel.text = "\(SharedUserLocation.currentSpeed)\nkm/h"
        if SharedUserLocation.currentSpeed < 27 {
            speedometer.image = UIImage(named: "\(SharedUserLocation.currentSpeed)")
        } else {
            speedometer.image = UIImage(named: "26")
        }
        switch CityBug.sharedInstance.batteryStatus {
        case 0.0..<10.0:
            batteryImage.image = UIImage(named: "battery10")
        case 10.0..<20.0:
            batteryImage.image = UIImage(named: "battery20")
        case 20.0..<40.0:
            batteryImage.image = UIImage(named: "battery40")
        case 40.0..<60.0:
            batteryImage.image = UIImage(named: "battery60")
        case 60.0..<80.0:
            batteryImage.image = UIImage(named: "battery80")
        case 80.0...100.0:
            batteryImage.image = UIImage(named: "battery100")
        default:
            batteryImage.image = UIImage(named: "battery100")
        }
        batteryLabel.text = "\(Int(CityBug.sharedInstance.batteryStatus)) %"
        remainingDistance.text = "\(Int(CityBug.sharedInstance.remainingDistance))"
        remainingTime.text = "\(stringFromTimeInterval(CityBug.sharedInstance.remainingTime))"
        if SaveAssistant.sharedInstance.tempRoutes.count > 1 {
            let traveledTimeInterval = SaveAssistant.sharedInstance.tempRoutes[0].timestamp.timeIntervalSinceNow
            traveledTime.text = "\(stringFromTimeInterval(-traveledTimeInterval))"
        }
        if SaveAssistant.sharedInstance.isRecording {
            let roundedDistance = round((SharedUserLocation.distance / 1000) * 100) / 100
            traveledDistance.text = "\(roundedDistance)"
        }
    }
    
    func volumeChanged(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        print("Volume is \(volume)")
        if volume < self.volume && (self.volume != 0 || self.volume != 1) {
            CityBug.sharedInstance.batteryStatus -= 8.750
        } else {
            CityBug.sharedInstance.batteryStatus += 8.750
        }
        self.volume = volume
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> NSString {
        
        let ti = NSInteger(interval)
        
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        return NSString(format: "%0.2d:%0.2d",hours,minutes)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timedUpdate", userInfo: nil, repeats: true)
        
        self.view.backgroundColor = CBDarkGray
        
        for label in [batteryLabel, traveledTime, remainingTime, traveledDistance, remainingDistance] {
            label.textColor = CBBlue
        }
        
        for backgroundView in [speedBackgroundView, distanceBackgroundView, batteryBackgroundView] {
            backgroundView.layer.backgroundColor = CBVeryDarkGray.CGColor
            backgroundView.layer.borderColor = UIColor.clearColor().CGColor
        }
        
        
        //volume buttons
        let volumeView = MPVolumeView(frame: CGRectMake(-CGFloat.max, 0.0, 0.0, 0.0))
        self.view.addSubview(volumeView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("volumeChanged:"), name: "AVSystemController_SystemVolumeDidChangeNotification", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

