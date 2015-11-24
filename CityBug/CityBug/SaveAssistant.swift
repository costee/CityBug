//
//  SaveAssistant.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 11..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/** SaveAssistant Class

*/
class SaveAssistant {
    
    var tempRoutes = [CLLocation]()
    
    dynamic var isRecording: Bool = false

    static let sharedInstance = SaveAssistant()

    private init(){}
    
    func saveImage(image: UIImage?, route: Route) {
        
        
        if let image = image {
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                if paths.count > 0 {
                    let documentsDirectory = paths[0]
                        
                        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.125, 0.125))
                        let hasAlpha = false
                        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
                        
                        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
                        image.drawInRect(CGRect(origin: CGPointZero, size: size))
                        
                        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        
                        let path = (documentsDirectory as NSString).stringByAppendingPathComponent(route.formattedStart(false) + ".jpg")
                        let data = UIImageJPEGRepresentation(scaledImage, 0.8)
                        data?.writeToFile(path, atomically: true)
                    }
        }
    }
    
    func loadImage(route: Route) -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory = paths[0]
                let path = (documentsDirectory as NSString).stringByAppendingPathComponent(route.formattedStart(false) + ".jpg")
                let image = UIImage(contentsOfFile: path)
                return image
    }
    
    func deleteImage(route: Route) {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory = paths[0]
                let path = (documentsDirectory as NSString).stringByAppendingPathComponent(route.formattedStart(false) + ".jpg")
                let fileManager = NSFileManager.defaultManager()
                do {
                    try fileManager.removeItemAtPath(path)
                } catch _ {
                }
    }
}
