//
//  ItemModel.swift
//  Assignment1
//
//  Created by Phearith on 3/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct ItemModel {
    var name:String! = ""
    var type:String! = ""
    var price:Double! = 0.0
    var date:Date! = nil
    
    init(name:String, type:String, price:Double, date:Date) {
        self.name = name
        self.type = type
        self.price = price
        self.date = date
    }
}
