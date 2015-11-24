//
//  StatisticsPageViewController.swift
//  CityBug
//
//  Created by Nagy Konstantin on 2015. 08. 06..
//  Copyright (c) 2015. Nagy Konstantin. All rights reserved.
//

import UIKit
import Charts

class StatisticsPageViewController: UIViewController {

    @IBOutlet weak var graphView: BarChartView!
    
    var pageIndex:Int!
    
    var months: [String]!
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        graphView.backgroundColor = UIColor.whiteColor()
        graphView.noDataText = "You need to provide data for the chart."
        
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        switch pageIndex {
        case 0: let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "km")
            graphView.descriptionText = "Driven distances"
            let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
            graphView.data = chartData
            chartDataSet.colors = [CBBlue]
        case 1: let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "km/h")
            graphView.descriptionText = "Maximum speed"
            let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
            graphView.data = chartData
            chartDataSet.colors = [CBRed]
        case 2: let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "km/h")
            graphView.descriptionText = "Average speed"
            let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
            graphView.data = chartData
            chartDataSet.colors = [CBGreen]
        default: break
        }
        
    }
    
    
    func getResults(detail: String) -> [Double] {
        var values = Array(count: 12, repeatedValue: 0.0)
        for var index = 0; index < RouteStore.sharedInstance.count; index++ {
            Year.sharedInstance.addRoute(RouteStore.sharedInstance.get(index))
        }
        let routesByMonth = Year.sharedInstance.routesByMonth()
        for (index,routes) in routesByMonth.enumerate() {
            for route in routes {
                switch detail {
                    case "distance": values[index] += route.distance
                case "maximum": values[index] = values[index] < route.maxSpeed ? route.maxSpeed : values[index]
                case "average": values[index] = values[index] == 0 ? route.averageSpeed : (values[index] + route.averageSpeed)/2
                default: values[index] = 0.0
                }
                
            }
        }
        return values
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        switch (pageIndex) {
        case 0: let drivenDistances = getResults("distance")
            setChart(months, values: drivenDistances)
        case 1: let maxSpeeds = getResults("maximum")
        setChart(months, values: maxSpeeds)
        case 2: let avgSpeeds = getResults("average")
        setChart(months, values: avgSpeeds)
        default: graphView.backgroundColor = UIColor.grayColor()
        }

        // Do any additional setup after loading the view.
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
