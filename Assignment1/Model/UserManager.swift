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
            user.image = sumUser[i].image
        }
        user.budget = budgetToDouble!
        appDelegate.saveContext()
    }
    
    func changeUserName(_ name:String) {
        let user = User(context: object)
        for i in 0 ..< sumUser.count {
            user.budget = sumUser[i].budget
            user.image = sumUser[i].image
        }
        user.name = name
        appDelegate.saveContext()
    }
    
    func changeUserImage(_ image:UIImage) {
        let user = User(context: object)
        for i in 0 ..< sumUser.count {
            user.budget = sumUser[i].budget
            user.name = sumUser[i].name
        }
        user.image = UIImageJPEGRepresentation(image, 1)
        appDelegate.saveContext()
    }
    
    func deleteCurrentImage() {
        let user = User(context: object)
        let defaultImage:UIImage = UIImage(named: "defaultUser")!
        user.image = nil
        user.image = UIImageJPEGRepresentation(defaultImage, 1)
        for i in 0 ..< sumUser.count {
            user.budget = sumUser[i].budget
            user.name = sumUser[i].name
        }
        appDelegate.saveContext()
    }
    
    func profileSum() -> (String, String, String, String, UIImage) {
        itemManager.loadItems()
        loadUser()
        var monthExpense:Double = 0.00
        var (monthAmount, remainBudget, userBudget, userName) = ("", "", "", "")
        var userImage:UIImage = UIImage(named: "defaultUser")!
        let totalItem = itemManager.sumItem
        let monthRange = Date().startOfMonth...Date().endOfMonth                                                  //define month range
        if totalItem.count > 0 {
            for i in 0 ..< totalItem.count {
                if monthRange.contains(totalItem[i].date!){                                            //find the sum of this month expense if database exist
                    monthExpense += totalItem[i].price
                }
            }
        }else {
            monthAmount = "No Expense Yet"
            remainBudget = "No Budget"
        }
        for i in 0 ..< sumUser.count {
            monthAmount = String(format: "$%.02f", monthExpense as CVarArg)                     //calculate this month expense
            remainBudget = String(format: "$%.02f", sumUser[i].budget - monthExpense as CVarArg)
            if sumUser[i].budget == 0.0 {
                userBudget = "No Budget"
            }else {
                userBudget = "$" + String(sumUser[i].budget)
            }
            if (sumUser[i].image == nil) {
                let defaultImage:UIImage = UIImage(named: "defaultUser")!
                sumUser[i].image = UIImageJPEGRepresentation(defaultImage, 1)
                userImage = defaultImage
            }else {
                let image = sumUser[i].image
                userImage = UIImage(data: image!)!
            }
            userName = sumUser[i].name ?? "User"
        }
        return (userName, monthAmount, remainBudget, userBudget, userImage)
    }
}
