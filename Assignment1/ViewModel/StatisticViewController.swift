//
//  StatisticViewController.swift
//  Assignment1
//
//  Created by Phearith on 3/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import Charts


class StatisticViewController: UIViewController {
    
    private var homeViewController = ViewController()
    
    let statType : [String] = ["Foods", "Services", "Shopping", "Others"]
    var statValue : [Double] = [0.0, 0.0, 0.0, 0.0]
    var totalFoods : Double = 0.0
    var totalServices : Double = 0.0                            //declare required variables for statistics scene pie chart
    var totalShop : Double = 0.0
    var totalOthers : Double = 0.0
    var foodsPerc : Double = 0.0
    var servicesPerc : Double = 0.0
    var shoppingsPerc : Double = 0.0                            //to calculate percentage for the pie chart
    var othersPerc : Double = 0.0
    
    
    @IBOutlet weak var statChart: PieChartView!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var avgDayLabel: UILabel!
    @IBOutlet weak var lastMonthExpenseLabel: UILabel!
    @IBOutlet weak var biggestSpentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastMonthExp()                                                  //call today expense, this month, last month and total expense function
        totalExp()
        biggestSpent()                                                  //to the app when it starts
        getChartData()  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)                                            //call neccessary function that needs to be updated
        lastMonthExp()                                                  //call today expense, this month, last month and total expense function
        totalExp()
        biggestSpent()
        getChartData()                                              //when the user switch tabs
    }

    
    // get data and assign to chart function
    func getChartData() {
        let totalItem = globalItem
        if totalItem.count > 0 {                                            //count if database exist
            totalFoods = statValue[0]
            totalServices = statValue[1]                                    //set value to array index
            totalShop = statValue[2]
            totalOthers = statValue[3]
            for i in 0 ..< totalItem.count {
                if sumItem[i].itemType == "Foods" {
                    totalFoods += totalItem[i].itemPrice
                } else if sumItem[i].itemType == "Services" {                   //sort data into each category
                    totalServices += totalItem[i].itemPrice
                } else if sumItem[i].itemType == "Shopping" {
                    totalShop += totalItem[i].itemPrice
                } else if sumItem[i].itemType == "Others" {
                    totalOthers += totalItem[i].itemPrice
                }
            }
            let totalAmount = totalFoods + totalServices + totalShop + totalOthers
            foodsPerc = totalFoods / totalAmount * 100
            servicesPerc = totalServices / totalAmount * 100                //calculate the item to get percentage for pie chart
            shoppingsPerc = totalShop / totalAmount * 100
            othersPerc = totalOthers / totalAmount * 100
            
            statValue.removeAll()
            statValue.append(foodsPerc)
            statValue.append(servicesPerc)                                  //set value to array
            statValue.append(shoppingsPerc)
            statValue.append(othersPerc)
            customizeChart(dataPoints: statType, values: statValue.map{Double($0)})       //trigger the chart with the ready value
        }else {
            print("No expense yet")
        }
    }
    
    
    //fill chart data and customise the chart
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .percent
        format.multiplier = 1.0
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // 4. Assign it to the chart's data
        statChart?.noDataText = "No Data Available"
        statChart?.centerText = "Overall Expenses"
        let d = Description()
        d.text = "Total Expenses in Pie Chart"
        statChart?.chartDescription? = d
        statChart?.data = pieChartData
    }
    
    
    // random color for charts
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        colors.append(UIColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 130.0/255.0, green: 224.0/255.0, blue: 170.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 236.0/255.0, green: 112.0/255.0, blue: 99.0/255.0, alpha: 1.0))
        colors.append(UIColor(red: 244.0/255.0, green: 208.0/255.0, blue: 63.0/255.0, alpha: 1.0))
        return colors
    }
    
    
    // total expense and avg expense function
    func totalExp() {
        let totalItem = globalItem
        if totalItem.count > 0 {                                                    //count if database exist
            var totalExpense:Double = 0.00
            for i in 0 ..< sumItem.count {
                totalExpense += sumItem[i].itemPrice                                    //calculate sum of all item price
            }
            let totalAmount = String(format: "$%.02f", totalExpense as CVarArg)
            totalExpenseLabel?.text = totalAmount                                   //set total expense text
            
            let avgAmount = String(format: "$%.02f", totalExpense/30 as CVarArg)    //calculate average amount
            avgDayLabel?.text = avgAmount                                           //and set it to average label
        }
        else {
            totalExpenseLabel?.text = "No Expense Yet"                              //exception if no database found
            avgDayLabel?.text = "No Average Found"
        }
    }
    
    
    //calculate expense for last month
    func lastMonthExp() {
        sumItem = globalItem
        let lastMonthRange = Date().startOfLastMonth...Date().endOfLastMonth                                                  //define last month range
        
        if sumItem.count > 0 {
            var lastMonthExpense:Double = 0.00
            for i in 0 ..< sumItem.count {
                if lastMonthRange.contains(sumItem[i].itemDate){                                                    //sum of last month expense
                    lastMonthExpense += sumItem[i].itemPrice
                }
            }
            let lastMonthAmount = String(format: "$%.02f", lastMonthExpense as CVarArg)
            lastMonthExpenseLabel?.text = lastMonthAmount                                                       //set value to label
        }
        else {
            lastMonthExpenseLabel?.text = "No Data Yet"                                                         //if no data from last month found
        }
    }
    
    func biggestSpent() {
        sumItem = globalItem
        let monthRange = Date().startOfMonth...Date().endOfMonth                                                  //define month range
        if sumItem.count > 0 {
            var biggestSpent:Double?
            for i in 0 ..< sumItem.count {
                if monthRange.contains(sumItem[i].itemDate){                                            //find the sum of this month expense if database exist
                    biggestSpent = sumItem.map{$0.itemPrice}.max()
                }
            }
            let bigSpent = String(format: "$%.02f", biggestSpent ?? 0)                       //find the biggest spent of the month
            biggestSpentLabel?.text = bigSpent
        }
        else {
            biggestSpentLabel?.text = "No Data Yet"
        }
    }

}
