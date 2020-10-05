//
//  ItemCategory.swift
//  Assignment1
//
//  Created by Phearith on 3/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

enum ItemCategory: String {
    case food, shopping, service, others
    
    var ItemImage: String {
        switch self {
        case .food: return "food"
        case .shopping: return "shopping"
        case .service: return "service"
        case .others: return "others"
        }
    }
}
