//
//  ViewModel.swift
//  Assignment1
//
//  Created by Phearith on 30/9/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation
import UIKit

struct ItemViewModel{
    
    private var model = REST_Request.sharedInstance
    
    var delegate: Refresh?{
        get{
            return model.delegate
        }
        set (value)
        {
            model.delegate = value
        }
    }
    
    var count: Int{
        return items.count
    }
    
    var items:[ItemModel]
    {
        return model.items
    }
    
    init(){
        
    }
    
    func getNameFor(index: Int) -> String
    {
        return items[index].itemName
    }
    
    func getPriceFor(index: Int) -> String
    {
        return items[index].itemPrice.description
    }

    
//    func getItemImageFor(index: Int) -> UIImage?
//    {
//        return recipes[index].image
//    }
    
    mutating func getItem()
    {
        model.getItem()
        
    }
}
