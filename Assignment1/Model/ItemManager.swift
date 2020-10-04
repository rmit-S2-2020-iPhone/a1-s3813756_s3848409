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
    
    private (set) var items:[Item] = []{
        willSet{
            print()
        }
    }
    
    static let sharedInstance = ItemManager()
    
    // Get a reference to your App Delegate
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Hold a reference to the managed context
    var object:NSManagedObjectContext!
    
    
    private init(){
        object = appDelegate?.persistentContainer.viewContext
        loadItems()
        print()
    }
    
    private func loadItems() {
        do
        {
            let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName:"Item")
            
            let results = try object?.fetch(fetchRequest)
            items = results as! [Item]
        }
        catch let error as NSError {
            print ("Could not fetch \(error) , \(error.userInfo )")
        }
    }
    
    func saveItem(_ name:String, _ type:String, _ price:Double, _ date:Date) {
        let item = Item(context: object)
        item.name = name
        item.price = price
        item.date = date
        
        if (selectedType == "Foods") {
            item.type = "Foods"
        }else if (selectedType == "Services") {
            item.type = "Services"
        }else if (selectedType == "Utilities") {
            item.type = "Utilities"
        }else if (selectedType == "Rent") {
            item.type = "Rent"
        }else if (selectedType == "Groceries") {
            item.type = "Groceries"
        }else{
            item.type = "Others"
        }
        appDelegate?.saveContext()
        
        loadItems()
    }
    
}
