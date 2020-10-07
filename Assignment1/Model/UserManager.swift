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
    var sumUser:[User] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let object:NSManagedObjectContext!
    
    
    private (set) var user:[User] = []{
        willSet{
            print()
        }
    }
    
    private init(){
        object = appDelegate.persistentContainer.viewContext
        loadUser()
    }
    
    func loadUser(){
        let userRequest:NSFetchRequest<User> = User.fetchRequest()
        do {
            try user = object.fetch(userRequest)
            sumUser = user
        }catch {
            print("Could not load user")
        }
    }
    
    func changeBudget(_ budget:String) {
        let user = User(context: object)
        let budgetToDouble:Double? = budget.toDouble()
        for i in 0 ..< sumUser.count {
            user.name = sumUser[i].name
        }
        user.budget = budgetToDouble!
        appDelegate.saveContext()
    }
    
    func changeUserName(_ name:String) {
        let user = User(context: object)
        for i in 0 ..< sumUser.count {
            user.budget = sumUser[i].budget
        }
        user.name = name
        appDelegate.saveContext()
    }
    
    func profileSum() -> (String, String, String, String) {
        itemManager.loadItems()
        loadUser()
        var monthAmount:String = ""
        var remainBudget:String = ""
        var userBudget:String = ""
        var userName:String = ""
        let totalItem = itemManager.sumItem
        let monthRange = Date().startOfMonth...Date().endOfMonth                                                  //define month range
        if totalItem.count > 0 {
            var monthExpense:Double = 0.00
            for i in 0 ..< totalItem.count {
                if monthRange.contains(totalItem[i].date!){                                            //find the sum of this month expense if database exist
                    monthExpense += totalItem[i].price
                }
            }
            for i in 0 ..< sumUser.count {
                monthAmount = String(format: "$%.02f", monthExpense as CVarArg)                     //calculate this month expense
                remainBudget = String(format: "$%.02f", sumUser[i].budget - monthExpense as CVarArg)
                userBudget = "$" + String(sumUser[i].budget)
                userName = sumUser[i].name ?? "No User"
            }
        }
        else {
            monthAmount = "No Expense Yet"
            remainBudget = "No Remaining Budget"
        }
        return (userName, monthAmount, remainBudget, userBudget)
    }
    
    
}
