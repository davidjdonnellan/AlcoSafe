//
//  BarViewController.swift
//  AlcoholMonitor
//
//  Created by David Donnellan on 04/11/2018.
//  Copyright © 2018 CS_UCC. All rights reserved.
//

import UIKit
import Charts


var newnumberOfDataEntries = [BarChartDataEntry]()

class BarViewController: UIViewController {

    @IBOutlet weak var resultTable: UITableView!
    @IBOutlet weak var NewBarChart: BarChartView!
    var tempColorArray:Array<NSUIColor> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidAppear(true)
        
        /// sets parameters for BarChart and how it is displayed
        NewBarChart.xAxis.drawAxisLineEnabled = false
        NewBarChart.xAxis.drawGridLinesEnabled = false
        NewBarChart.leftAxis.drawGridLinesEnabled = false
        NewBarChart.rightAxis.drawGridLinesEnabled = false
        NewBarChart.leftAxis.drawAxisLineEnabled = false
        NewBarChart.rightAxis.drawAxisLineEnabled = false
        NewBarChart.legend.enabled = false
        
        let userDefaults = UserDefaults.standard
        let array = userDefaults.object(forKey: "BACArray") as! Array<Double>
        resultTable.dataSource = self
        resultTable.delegate = self
        
        
        
    // this for loop adds specific colours to an array which displays the colours related to moderate to dangerous BAC readings the array created is used in updateChart function below to display appropriate colors on chart
        var count = 0
        for values in array{
            let xdataEntry = BarChartDataEntry(x: Double(count), y: values)
            count += 1
            newnumberOfDataEntries += [xdataEntry]
            if values <= 0.1{
                tempColorArray  += [UIColor.green]
            }
            else if values > 0.1 && values <= 0.2{
             tempColorArray += [UIColor.yellow]
            }
            else if   values > 0.2 && values <= 0.3{
                tempColorArray += [UIColor.orange]
            }
            else{
                tempColorArray += [UIColor.red]
       
            }
        }
        updateChart()
    }
    
    //updates the BarChart with data retrieved from persistent storage
    func updateChart(){
        let chartDataSet = BarChartDataSet(values:newnumberOfDataEntries, label: "Alcohol Consumed Each Drinking Period")
        let chartData = BarChartData(dataSet: chartDataSet)
        let colors = tempColorArray
        chartDataSet.colors = colors
        chartDataSet.barShadowColor = UIColor.gray
        NewBarChart.data = chartData
        tempColorArray = []
    }
    
    // updates charts when user navigates to the chart view
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

}

// this extension alls the data to be displayed on table within the view
// the tableView code is boileplate code necessary to display tables within the applcaiton
// resuable cells are used as they take up less memory and processing power making the applicaiton more efficient
extension BarViewController: UITableViewDataSource, UITableViewDelegate {
   
    // reason for having to define the array twice is that an extension doesnt allow the retrieval of a persistant object
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let userDefaults = UserDefaults.standard
        let newarray = userDefaults.object(forKey: "BACArray") as! Array<Double>
        return newarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userDefaults = UserDefaults.standard
        var newarray = userDefaults.object(forKey: "BACArray") as! Array<Double>
        // Default cell
        let cell = resultTable.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        
        cell.textLabel!.text = "BAC: " +  String(format: "%.4f",newarray[indexPath.row])
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)

        if newarray[indexPath.row] <= 0.1{
            cell.textLabel?.textColor = UIColor.green
        }
        else if newarray[indexPath.row] > 0.1 && newarray[indexPath.row] <= 0.2{
            cell.textLabel?.textColor = UIColor.yellow
        }
        else if newarray[indexPath.row] > 0.2 && newarray[indexPath.row] <= 0.3{
           cell.textLabel?.textColor = UIColor.orange
        }
        else{
           cell.textLabel?.textColor = UIColor.red
        }
        return cell;
    }
    
    
}
    
  


