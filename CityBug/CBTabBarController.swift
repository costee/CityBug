//
//  CBTabBarController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 04..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit

class CBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        var temp: Int = self.selectedIndex
        if (sender.direction == .Left && self.selectedIndex == 0) {
                temp += 1
        }
        
        if (sender.direction == .Right && self.selectedIndex == 1) {
                temp -= 1
        }
        
        if temp == 1 {
            darkenUI()
        } else {
            defaultUI()
        }
        
        self.selectedIndex = temp
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Dashboard" {
            darkenUI()
        } else {
            defaultUI()
        }
    }
    
    func darkenUI() {
        self.tabBar.barTintColor = CBVeryDarkGray
        UINavigationBar.appearance().barTintColor = CBVeryDarkGray
        UINavigationBar.appearance().barStyle = UIBarStyle.BlackTranslucent
    }
    
    func defaultUI(){
        self.tabBar.barTintColor = nil
        self.tabBar.barStyle = UIBarStyle.Default
        UINavigationBar.appearance().barTintColor = nil
        UINavigationBar.appearance().barStyle = UIBarStyle.Default
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
