//
//  UserManager.swift
//  Assignment1
//
//  Created by Phearith on 6/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class UserManager {
    private var itemManager = ItemManager.sharedInstance
    static let sharedInstance = UserManager()
    
    // Get a reference to your App Delegate
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Hold a reference to the managed context
    var object:NSManagedObjectContext!
    
    private (set) var user:[User] = []{
        willSet{
            print()
        }
    }
    
    private init(){
        object = appDelegate?.persistentContainer.viewContext
        loadUser()
    }
    
    func loadUser(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        do {
            try user = object.fetch(userRequest)
        }catch {
            print("Could not load user")
        }
    }
    
    func getUserInfo() -> (String, String) {
        loadUser()
        let user = User(context: object)
        let userName = user.name ?? ""
        let userBudget = String(user.budget)
        return (userName, userBudget)
    }
    
    func changeBudget(_ budget:String) -> String {
        let user = User(context: object)
        let budgetToDouble:Double? = budget.toDouble()
        user.budget = budgetToDouble!
        appDelegate?.saveContext()
        loadUser()
        let newBudget = String(user.budget)
        return newBudget
    }
    
    func changeUserName(_ name:String) {
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        userRequest.predicate = NSPredicate(format: "name = %@", name)
        do {
            let results = try object.fetch(userRequest) as [NSManagedObject]
            if results.count != 0 {
                results[0].setValue(name, forKey: "name")
                appDelegate?.saveContext()
                loadUser()
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
    }
    
    func profileSum() -> (String, String, String) {
        itemManager.loadItems()
        loadUser()
        let user = User(context: object)
        var monthAmount:String = ""
        var remainBudget:String = ""
        var userBudget:String = ""
        let totalItem = itemManager.sumItem
        let monthRange = Date().startOfMonth...Date().endOfMonth                                                  //define month range
        if totalItem.count > 0 {
            var monthExpense:Double = 0.00
            for i in 0 ..< totalItem.count {
                if monthRange.contains(totalItem[i].date!){                                            //find the sum of this month expense if database exist
                    monthExpense += totalItem[i].price
                }
            }
            monthAmount = String(format: "$%.02f", monthExpense as CVarArg)                     //calculate this month expense
            remainBudget = String(format: "$%.02f", user.budget - monthExpense as CVarArg)           //calculate remaining budget base on user's current budget
            userBudget = "$" + String(user.budget)
        }
        else {
            monthAmount = "No Expense Yet"
            remainBudget = "No Remaining Budget"
            userBudget = "No Budget Found"
        }
        return (monthAmount, remainBudget, userBudget)
    }
    
    
}
