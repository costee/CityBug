//
//  StatisticsRootViewController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 06..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit

class StatisticsRootViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController: UIPageViewController!
    
    let statisticsCount = 3

    @IBAction func debugSizes(sender: UIBarButtonItem) {
        
        
        
        print("width: \(self.view.frame.size.width)")
        print("height: \(self.view.frame.size.height)")

    }
    
    func setViewSize() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let portraitNavigationBarPadding = 84
        let landscapeNavigationBarPadding = 52
        let tabBarPadding = 49
        let sidePadding = 20
        
        let currentDevice: UIDevice = UIDevice.currentDevice()
        let orientation: UIDeviceOrientation = currentDevice.orientation
        
        
        if orientation.isLandscape {
            self.pageViewController.view.frame = CGRectMake(CGFloat(sidePadding), CGFloat(landscapeNavigationBarPadding), CGFloat(Int(width) - (2*sidePadding)) , CGFloat(Int(height) - (landscapeNavigationBarPadding + tabBarPadding)))
        } else {
            self.pageViewController.view.frame = CGRectMake(CGFloat(sidePadding), CGFloat(portraitNavigationBarPadding), CGFloat(Int(width) - (2*sidePadding)) , CGFloat(Int(height) - (portraitNavigationBarPadding + tabBarPadding)))
        }
        
        
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        setViewSize()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = nil
        UINavigationBar.appearance().barStyle = UIBarStyle.Default

        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Statistics") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let initialContenViewController = self.statisticsPageAtIndex(0) as StatisticsPageViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        setViewSize()
        
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

        
        
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func statisticsPageAtIndex(index: Int) ->StatisticsPageViewController
    {
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StatisticsPageViewController") as! StatisticsPageViewController
        
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
        
    }
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let viewController = viewController as! StatisticsPageViewController
        var index = viewController.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index--
        
        return statisticsPageAtIndex(index)
        
    }
    
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let viewController = viewController as! StatisticsPageViewController
        var index = viewController.pageIndex as Int
        
        if((index == NSNotFound))
        {
            return nil
        }
        
        index++
        
        if(index == statisticsCount)
        {
            return nil
        }
        
        return statisticsPageAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int // The number of items reflected in the page indicator.
    {
        return statisticsCount
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int // The selected item reflected in the page indicator.
    {
        return 0
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
