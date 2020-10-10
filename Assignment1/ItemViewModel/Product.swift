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
    
    static let baseURL = "https://fakestoreapi.com/products"
    
    static func rest_request(){
        guard let url = URL(string: baseURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String:Any]] else { return }
                var product = [Product]()
                for dic in jsonArray{
                    product.append(Product(dic))
                }
                for i in 0 ..< product.count {
                    print("Title: \(product[i].title)\nType: \(product[i].category)\nPrice: \(product[i].price)\nDescription: \(product[i].desc)\n")
                }
            } catch let parsingError{
                print("Error", parsingError)
            }
            
        }
        task.resume()
    }
    
}
