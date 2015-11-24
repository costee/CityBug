//
//  CBYear.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 26..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import Foundation

let currentYear = (NSCalendar.autoupdatingCurrentCalendar().components(.Year, fromDate: NSDate())).year

var isCurrentYearLeap: Bool {
    get {
        if currentYear % 4 == 0 {
            if currentYear % 100 == 0 {
                if currentYear % 400 == 0 {
                    return true
                } else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }
}

class Month {
    var routesMatrix: [[Route]]!
    let count: Int
    let start = NSDateComponents()
    init(month: Int, count: Int) {
        start.year = currentYear
        start.month = month
        start.day = 1
        self.count = count
        
        routesMatrix = Array(count: self.count, repeatedValue: [Route]())
    }
    
    func allRoutes() -> [Route] {
        var routes = [Route]()
        for routesArray in self.routesMatrix {
            for innerRoute in routesArray {
                routes.append(innerRoute)
            }
        }
        return routes
    }
    
    func addRoute(route:Route) {
        let routeMonth = (NSCalendar.autoupdatingCurrentCalendar().components(.Month, fromDate: route.start)).month
        if routeMonth == start.month {
            routesMatrix[(NSCalendar.autoupdatingCurrentCalendar().components(.Day, fromDate: route.start)).day].append(route)
        }
    }
}

class Year {
    
    static let sharedInstance = Year()
    
    private init(){}

    var January = Month(month: 1, count: 31)
    var February = Month(month: 2, count: isCurrentYearLeap ? 28 : 29)
    var March = Month(month: 3, count: 31)
    var April = Month(month: 4, count: 30)
    var May = Month(month: 5, count: 31)
    var June = Month(month: 6, count: 30)
    var July = Month(month: 7, count: 31)
    var August = Month(month: 8, count: 31)
    var September = Month(month: 9, count: 30)
    var October = Month(month: 10, count: 31)
    var November = Month(month: 11, count: 30)
    var December = Month(month: 12, count: 31)
    
    
    
    func addRoute(route: Route) {
        let Months = [January, February, March, April, May, June, July, August, September, October, November, December]
        for month in Months {
            month.addRoute(route)
        }
    }
    
    func routesByMonth() -> [[Route]] {
        let Months = [January, February, March, April, May, June, July, August, September, October, November, December]
        var everyRoute = Array(count: 12, repeatedValue: [Route]())
        for (index,month) in Months.enumerate() {
            everyRoute[index] = month.allRoutes()
        }
        return everyRoute
    }
    
    }