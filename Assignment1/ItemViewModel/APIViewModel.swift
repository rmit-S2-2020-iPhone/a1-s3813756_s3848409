//
//  APIViewModel.swift
//  Assignment1
//
//  Created by Phearith on 11/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation
import UIKit

struct APIViewModel {
    private var model = ProductAPI.sharedInstance
    var products:[Product] = []
    
    
    var delegate: Refresh? {
        get {
            return model.delegate
        }
        set (value) {
            model.delegate = value
        }
    }
    
    
    mutating func rest_request() {
        model.rest_request()
        products = model.products
    }
    
    mutating func addItem(_ name:String, _ type:String, _ price:Double, _ date:Date) {
        model.addItem(name, type, price, date)
    }
}
