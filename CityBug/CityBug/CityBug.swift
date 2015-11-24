//
//  CityBug.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 18..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation

/** CityBug Class

*/
class CityBug {

    static let sharedInstance = CityBug()

    private init(){}
    
    var batteryStatus = 100.0
    
    let maxDistance = 20.0 //kms
    
    var remainingDistance: Double {
        get {
            return self.maxDistance * batteryStatus / 100
        }
    }
    
    var remainingTime: NSTimeInterval {
        get {
            return NSTimeInterval(1000 * batteryStatus  - Double(SharedUserLocation.currentSpeed) * 100) //seconds
        }
    }
    
}
