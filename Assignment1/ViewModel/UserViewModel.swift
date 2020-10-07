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
    
    mutating func getProfileSum() -> (String, String, String, String) {
        let (userName, monthAmount, remainBudget, userBudget) = userManager.profileSum()
        return (userName, monthAmount, remainBudget, userBudget)
    }
    
    mutating func changeBudget (_ newBudget:String){
        userManager.changeBudget(newBudget)
    }
    
    mutating func changeUserName (_ newUserName:String) {
        userManager.changeUserName(newUserName)
    }

}
