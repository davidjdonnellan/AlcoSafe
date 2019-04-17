//
//  ChartViewController.swift / USER DASHBOARD
//  AlcoholMonitor
//
//  Created by David Donnellan on 02/10/2018.
//  Copyright © 2018 CS_UCC. All rights reserved.
//

import UIKit
import Charts
import FirebaseFirestore


// initialise datatype that charts library uses
var dataEntry = PieChartDataEntry(value: 0)
var numberOfEntries = [PieChartDataEntry]()

class ChartViewController: UIViewController {
    
    @IBOutlet weak var weeklyCost: UILabel!
    @IBOutlet weak var monthlyCost: UILabel!
    @IBOutlet weak var annualCost: UILabel!
    
    @IBOutlet weak var weeklyUnit: UILabel!
    @IBOutlet weak var monthlyUnit: UILabel!
    @IBOutlet weak var annualUnit: UILabel!
    
    @IBOutlet weak var weeklyCal: UILabel!
    @IBOutlet weak var monthlyCal: UILabel!
    @IBOutlet weak var annualCal: UILabel!
    
    
    // initialises the piechart from charts framework
    @IBOutlet weak var NewPieChart: PieChartView!
    var test = PieChartData()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        super.viewDidAppear(true)
     
         // following code retrieves user data from persistent storage and uses data to display statistics to user on the dasboard screen
        NewPieChart.chartDescription?.text = "Consumption as a percentage"
        NewPieChart.holeColor = UIColor(red: 208/255, green: 208/255, blue: 214/255, alpha: 1.0)
        NewPieChart.drawEntryLabelsEnabled = false
        let userDefaults = UserDefaults.standard
        let array = userDefaults.object(forKey: "BACArray") as! Array<Double>
        let units = userDefaults.double(forKey: "unit")
        let calories = userDefaults.double(forKey: "cal")
        let cost = userDefaults.double(forKey: "cost")
        userDefaults.synchronize()
        
        weeklyCost.text = "€" + String(format: "%.2f",cost/52)
        monthlyCost.text = "€" + String(format: "%.2f",cost/12)
        annualCost.text = "€" + String(format: "%.2f",cost)
        weeklyCal.text =  String(format: "%.0f",calories/52)
        monthlyCal.text = String(format: "%.0f",calories/12)
        annualCal.text = String(format: "%.0f",calories)
        weeklyUnit.text = String(format: "%.1f",units/52)
        monthlyUnit.text = String(format: "%.1f",units/12)
        annualUnit.text = String(format: "%.1f",units)

        
        // this code counts the amount of times a spcific range of numbers appears in array for displaying the data as a percantage on the pie chart
        var count = 0.0
        var low = 0.0
        var medium = 0.0
        var high = 0.0
        var dangerous = 0.0
        var dataEntry = PieChartDataEntry()
        for values in array{
          if array.count >= 1{
            if values <= 0.1{
                low += 1.0
                count += 1.0
            }
            else if values > 0.1 && values <= 0.2{
                medium += 1.0
                count+=1.0
            }
            else if   values > 0.2 && values <= 0.3{
                high += 1.0
                count+=1.0
            }
            else{
                dangerous += 1.0
                count+=1.0
            }
            }
        }
        
        // maths needed to change the user data to display percentages of moderate to excessive drinking on the pie chart and to add the data to the created datatype array that the chart library uses to read data
        dataEntry = PieChartDataEntry(value: (dangerous/count)*100.0)
        numberOfEntries += [dataEntry]
        dataEntry.label = "Dangerous Consumption"
        dataEntry = PieChartDataEntry(value: (high/count)*100.0)
        numberOfEntries += [dataEntry]
        dataEntry.label = "High Consumption"
        dataEntry = PieChartDataEntry(value: (medium/count)*100.0)
        numberOfEntries += [dataEntry]
        dataEntry.label = "Moderate Consumption"
        dataEntry = PieChartDataEntry(value: (low/count)*100.0)
        numberOfEntries += [dataEntry]
        dataEntry.label = "Low Consumption"
        print(array)
        //numberOfDataEntries = [dataEntry]
        print("working")
        updateChart()
    }
    
     // updates the chart with the colors and data that was processed above
    func updateChart(){
       // trace!.incrementMetric("working", by: 1)
        let chartDataSet = PieChartDataSet( values:numberOfEntries, label: "Alcohol Consumed")
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor (named: "ChartColor"),UIColor.purple,UIColor(red: 54/255, green: 208/255, blue: 63/255, alpha: 1.0),UIColor.orange]
        chartDataSet.colors = colors as! [NSUIColor]
        NewPieChart.data = chartData
        numberOfEntries = []
    }
    
    // loads the viewDidLoad each time the user naviagates to the dashboard withint the applicaiton so that the data on the charts is refreshed after calculation
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
}
