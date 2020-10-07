//
//  ChartViewModel.swift
//  Assignment1
//
//  Created by Phearith on 6/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct ChartViewModel {
    private var chartManager = ChartManager.sharedInstance
    
    mutating func getChartValue() -> (Array<Double>, Array<String>) {
        let (statValue, statType) = chartManager.getChartData()
        return (statValue, statType)
    }
    
    mutating func getTotalExp() -> (String, String) {
        let (totalAmount, avgAmount) = chartManager.totalExp()
        return (totalAmount, avgAmount)
    }
    
    mutating func getLastMonthExp() -> String {
        let lastMonthExp = chartManager.lastMonthExp()
        return lastMonthExp
    }
    
    mutating func getBiggestSpent() -> String {
        let bigSpent = chartManager.biggestSpent()
        return bigSpent
    }
}
