//
//  ChartModel.swift
//  Assignment1
//
//  Created by Phearith on 3/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

class ChartManager {
    private var itemManager = ItemManager.sharedInstance
    static let sharedInstance = ChartManager()
    
    var statValue : [Double] = [0.0, 0.0, 0.0, 0.0]
    var (totalFoods, totalServices, totalShop, totalOthers) = (0.0, 0.0, 0.0, 0.0)
    var (foodsPerc, servicesPerc, shoppingsPerc, othersPerc) = (0.0, 0.0, 0.0, 0.0)
    
    func getChartData() -> (Array<Double>, Array<String>) {
        itemManager.loadItems()
        let statType : [String] = ["Foods", "Services", "Shopping", "Others"]
        let totalItem = itemManager.sumItem
        if totalItem.count > 0 {                                            //count if database exist
            totalFoods = statValue[0]
            totalServices = statValue[1]                                    //set value to array index
            totalShop = statValue[2]
            totalOthers = statValue[3]
            for i in 0 ..< totalItem.count {
                if totalItem[i].type == "Foods" {
                    totalFoods += totalItem[i].price
                } else if totalItem[i].type == "Services" {                   //sort data into each category
                    totalServices += totalItem[i].price
                } else if totalItem[i].type == "Shopping" {
                    totalShop += totalItem[i].price
                } else if totalItem[i].type == "Others" {
                    totalOthers += totalItem[i].price
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
            
        }else {
            statValue = [0.0, 0.0, 0.0, 0.0]
        }
        return (statValue, statType)
    }
    
    
    // total expense and avg expense function
    func totalExp() -> (String, String) {
        let totalItem = itemManager.sumItem
        var totalAmount:String = ""
        var avgAmount:String = ""
        if totalItem.count > 0 {                                                    //count if database exist
            var totalExpense:Double = 0.00
            for i in 0 ..< totalItem.count {
                totalExpense += totalItem[i].price                                    //calculate sum of all item price
            }
            totalAmount = String(format: "$%.02f", totalExpense as CVarArg)
            avgAmount = String(format: "$%.02f", totalExpense/30 as CVarArg)    //calculate average amount
        }
        else {
            totalAmount = "No Data Found"
            avgAmount = "No Data Found"
        }
        return (totalAmount, avgAmount)
    }
    
    
    //calculate expense for last month
    func lastMonthExp() -> String {
        var lastMonthAmount:String = ""
        let totalItem = itemManager.sumItem
        let lastMonthRange = Date().startOfLastMonth...Date().endOfLastMonth                                                  //define last month range
        
        if totalItem.count > 0 {
            var lastMonthExpense:Double = 0.00
            for i in 0 ..< totalItem.count {
                if lastMonthRange.contains(totalItem[i].date!){                                                    //sum of last month expense
                    lastMonthExpense += totalItem[i].price
                }
            }
            lastMonthAmount = String(format: "$%.02f", lastMonthExpense as CVarArg)
        }
        else {
            lastMonthAmount = "No Expense From Last Month"                                                         //if no data from last month found
        }
        return lastMonthAmount
    }
    
    func biggestSpent() -> String {
        let totalItem = itemManager.sumItem
        var bigSpent:String = ""
        let monthRange = Date().startOfMonth...Date().endOfMonth                                                  //define month range
        if totalItem.count > 0 {
            var biggestSpent:Double?
            for i in 0 ..< totalItem.count {
                if monthRange.contains(totalItem[i].date!){                                            //find the sum of this month expense if database exist
                    biggestSpent = totalItem.map{$0.price}.max()
                }
            }
            bigSpent = String(format: "$%.02f", biggestSpent ?? 0)                       //find the biggest spent of the month
        }
        else {
            bigSpent = "No Data Found"
        }
        return bigSpent
    }
}
