//
//  UserViewModel.swift
//  Assignment1
//
//  Created by Phearith on 6/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct UserViewModel {
    private var userManager = UserManager.sharedInstance
    
    mutating func getProfileSum() -> (String, String, String) {
        let (monthAmount, remainBudget, userBudget) = userManager.profileSum()
        return (monthAmount, remainBudget, userBudget)
    }
    
    mutating func changeBudget (_ newBudget:String) -> String{
        let newBudget = userManager.changeBudget(newBudget)
        return newBudget
    }
    
    mutating func changeUserName (_ newUserName:String) {
        userManager.changeUserName(newUserName)
        userManager.loadUser()
    }
    
    mutating func getUserInfo () -> (String, String) {
        let (userName, userBudget) = userManager.getUserInfo()
        return (userName, userBudget)
    }
    
    
}
