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

    @IBOutlet weak var statChart: PieChartView!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var avgDayLabel: UILabel!
    @IBOutlet weak var lastMonthExpenseLabel: UILabel!
    @IBOutlet weak var biggestSpentLabel: UILabel!
    
    private var chartViewModel = ChartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart()
        lastMonthExp()                                                  //call today expense, this month, last month and total expense function
        totalExp()
        biggestSpent()                                                  //to the app when it starts
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)                                            //call neccessary function that needs to be updated
        setChart()
        lastMonthExp()                                                  //call today expense, this month, last month and total expense function
        totalExp()
        biggestSpent()
    }

    func setChart() {
        let (statValue, statType) = chartViewModel.getChartValue()
        customizeChart(dataPoints: statType, values: statValue.map{Double($0)})       //trigger the chart with the ready value
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
        let desc = Description()
        desc.text = "Total Expenses in Pie Chart"
        statChart?.chartDescription? = desc
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
    
    func totalExp() {
        let (totalAmount, avgAmount) = chartViewModel.getTotalExp()
        avgDayLabel?.text = avgAmount
        totalExpenseLabel?.text = totalAmount
    }
    
    func biggestSpent() {
        let bigSpent = chartViewModel.getBiggestSpent()
        biggestSpentLabel?.text = bigSpent
    }
    
    func lastMonthExp() {
        let lastMonthAmount = chartViewModel.getLastMonthExp()
        lastMonthExpenseLabel?.text = lastMonthAmount
    }
}
