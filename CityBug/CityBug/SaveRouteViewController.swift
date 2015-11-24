//
//  SaveRouteViewController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 05..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit

class SaveRouteViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var saveRouteButton: UIBarButtonItem!
    
    @IBOutlet weak var titleView: UITextView!
    
    @IBOutlet weak var routeImageView: UIImageView!
    
    @IBOutlet weak var libraryButton: UIButton!
    
    @IBAction func saveRoute(sender: UIBarButtonItem) {
        
        let route:Route = Route()
        
        var startTimeStamp: NSDate = NSDate()
        
        for location in SaveAssistant.sharedInstance.tempRoutes {
            route.addRouteLocationFromCLLocation(location)
        }
        
        //setting timeStamp to be the earliest saved location
        for var index = 0; index < Int(route.routeLocations.count); ++index {
            if (route.routeLocations.objectAtIndex(UInt(index)) as! RouteLocation).timeStamp.compare(startTimeStamp) == .OrderedAscending {
                startTimeStamp = (route.routeLocations.objectAtIndex(UInt(index)) as! RouteLocation).timeStamp
            }
        }
        
        route.start = startTimeStamp
        route.title = titleView.text
        
        SaveAssistant.sharedInstance.saveImage(routeImageView.image, route: route)
        
        route.calculateStats()
        
        route.distance = SharedUserLocation.distance / 1000.0 //kilometers
        
        RouteStore.sharedInstance.addRoute(route)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    let placeholderText = "Enter title here"
    
    override func viewDidLoad() {
        
        saveRouteButton.tintColor = CBGreen
        titleView.text = placeholderText
        titleView.textColor = UIColor.lightGrayColor()
        titleView.delegate = self
        
        let tapImage:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("imagePicker"))
        tapImage.numberOfTapsRequired = 1
        routeImageView.addGestureRecognizer(tapImage)
        
        libraryButton.layer.borderWidth = 1
        libraryButton.layer.cornerRadius = 5
        libraryButton.layer.borderColor = CBBlue.CGColor
        libraryButton.tintColor = CBBlue
        super.viewDidLoad()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        titleView.text = ""
        titleView.textColor = UIColor.blackColor()
    
    }
    
    func imagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.allowsEditing = false
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func libraryPicker(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let bounds = self.routeImageView.bounds
        self.routeImageView.image = image
        self.routeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.routeImageView.bounds = bounds
        self.routeImageView.clipsToBounds = true
        
        dismissViewControllerAnimated(true, completion: nil)
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
