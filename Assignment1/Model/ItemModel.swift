//
//  ItemModel.swift
//  Assignment1
//
//  Created by Phearith on 4/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

var globalItem: [Item] = []
var sortedItem: [Item] = []
var sumItem: [Item] = []
var budget = 2000.0

struct ItemModel {
    var itemName:String! = ""
    var itemType:String! = ""
    var itemPrice:Double! = 0.0
    var itemDate:Date! = nil
    
    init(itemName:String, itemType:String, itemPrice:Double, itemDate:Date) {
        self.itemName = itemName
        self.itemType = itemType
        self.itemPrice = itemPrice
        self.itemDate = itemDate
    }
}
