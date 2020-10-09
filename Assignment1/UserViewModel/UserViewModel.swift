//
//  UserViewModel.swift
//  Assignment1
//
//  Created by Phearith on 6/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation
import UIKit

struct UserViewModel {
    private var userManager = UserManager.sharedInstance
    
    mutating func getProfileSum() -> (String, String, String, String, UIImage) {
        let (userName, monthAmount, remainBudget, userBudget, userImage) = userManager.profileSum()
        return (userName, monthAmount, remainBudget, userBudget, userImage)
    }
    
    mutating func changeBudget (_ newBudget:String){
        userManager.changeBudget(newBudget)
    }
    
    mutating func changeUserName (_ newUserName:String) {
        userManager.changeUserName(newUserName)
    }
    
    mutating func changeUserImage(_ newImage:UIImage) {
        userManager.changeUserImage(newImage)
    }
    
    mutating func deleteCurrentImage () {
        userManager.deleteCurrentImage()
    }
}
