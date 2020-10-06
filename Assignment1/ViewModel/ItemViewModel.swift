//
//  ItemViewModel.swift
//  Assignment1
//
//  Created by Phearith on 6/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct ItemViewModel {
    private var itemManager = ItemManager.sharedInstance
    var sortedItem:[Item] = []
    
    
    mutating func addItem(_ name:String, _ type:String, _ price:Double, _ date:Date) {
        itemManager.addItemToDatabase(name, type, price, date)
    }
    
    mutating func loadItems() {
        itemManager.loadItems()
    }
    
    mutating func sortItems(_ selectedType:String) {
        itemManager.sortData(selectedType)
        sortedItem = itemManager.sortedItem
    }
    
    mutating func deleteItems(_ item:Item) {
        itemManager.deleteItem(item)
    }
    
    mutating func todayExp() -> String {
        let todayExp = itemManager.todayExp()
        return todayExp
    }
}
