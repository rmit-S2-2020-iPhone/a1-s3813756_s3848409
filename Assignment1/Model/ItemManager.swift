//
//  ItemManager.swift
//  Assignment1
//
//  Created by Phearith on 4/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class ItemManager{
    
    var sortedItem:[Item] = []
    var sumItem:[Item] = []
    
    static let sharedInstance = ItemManager()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate     // Get a reference to your App Delegate
    private let object:NSManagedObjectContext!                                  // Hold a reference to the managed context
    
    private (set) var items:[Item] = []{
        willSet{
            print()
        }
    }

    private init(){
        object = appDelegate?.persistentContainer.viewContext
        loadItems()
    }
    
    func loadItems() {
        let itemRequest:NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            sumItem = items
        }catch {
            print("Could not load data")
        }
    }
    
    func addItemToDatabase(_ name:String, _ type:String, _ price:Double, _ date:Date) {
        let item = createItem(name, type, price, date)
        items.append(item)
        appDelegate?.saveContext()
        loadItems()
    }
    
    private func createItem(_ name:String, _ type:String, _ price:Double, _ date:Date) -> Item{
        let item = Item(context: object)
        item.name = name
        item.price = price
        item.date = date
        
        if (type == "Foods") {
            item.type = "Foods"
        }else if (type == "Shopping") {
            item.type = "Shopping"
        }else if (type == "Services") {
            item.type = "Services"
        }else{
            item.type = "Others"
        }
        return item
    }
    
    func sortData(_ selectedType:String) {
        let itemRequest:NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        itemRequest.sortDescriptors = [sortDescriptor]
        if selectedType == "Foods" {
            itemRequest.predicate = NSPredicate(format: "type = %@", "Foods")
        }else if selectedType == "Shopping" {
            itemRequest.predicate = NSPredicate(format: "type = %@", "Shopping")
        }else if selectedType == "Services" {
            itemRequest.predicate = NSPredicate(format: "type = %@", "Services")
        }else if selectedType == "Others" {
            itemRequest.predicate = NSPredicate(format: "type = %@", "Others")
        }
        do {
            try sortedItem = object.fetch(itemRequest)
        }catch {
            print("Could not load data")
        }
    }
    
    func deleteItem(_ item:Item) {
        let deleteItem = item
        object.delete(deleteItem as NSManagedObject)
        appDelegate?.saveContext()
        loadItems()
    }
    
    func updateItem(_ item:Item, _ newName:String, _ newPrice:Double, _ newType:String, _ newDate:Date) {
        let editItem = item
        editItem.name = newName
        editItem.price = newPrice
        editItem.date = newDate
        if (newType == "Foods") {
            editItem.type = "Foods"
        }else if (newType == "Shopping") {
            editItem.type = "Shopping"
        }else if (newType == "Services") {
            editItem.type = "Services"
        }else{
            editItem.type = "Others"
        }
        appDelegate?.saveContext()
    }
    
    func todayExp() -> String {
        loadItems()
        var totalAmount:String = ""
        let todayRange = Date().startOfDay...Date().endOfDay     //set today's range
        let totalItem = sumItem
        if totalItem.count > 0 {
            var total:Double = 0.00
            for i in 0 ..< totalItem.count {                                                      //calculate today's expense
                if todayRange.contains(totalItem[i].date!){
                    total += totalItem[i].price
                }
            }
            totalAmount = "- " + (NSString(format: "$%.02f", total as CVarArg) as String)
        }
        else {
            totalAmount = "- $0.00"                                                //exception if no data found
        }
        return totalAmount
    }
}
