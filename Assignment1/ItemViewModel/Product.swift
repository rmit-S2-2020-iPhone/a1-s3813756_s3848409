//
//  Currency.swift
//  Assignment1
//
//  Created by sokleng on 10/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct Product {
    let title:String
    let desc: String
    let price:Double
    let category:String
    
    
    init(_ dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.desc = dictionary["description"] as? String ?? ""
        self.price = dictionary["price"] as? Double ?? 0.00
        self.category = dictionary["category"] as? String ?? ""
    }
    
    
    

    
    
}
