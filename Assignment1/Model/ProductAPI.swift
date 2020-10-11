//
//  ProductAPI.swift
//  Assignment1
//
//  Created by Phearith on 11/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

protocol Refresh{
    func updateUI()
}

class ProductAPI {
    private var itemViewModel = ItemViewModel()
    static let sharedInstance = ProductAPI()
    var delegate: Refresh?
    var products = [Product]()
    private var utility = Utility()
    private let baseURL = "https://fakestoreapi.com/products"
    
    
    
    func rest_request(){
        guard let url = URL(string: baseURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String:Any]] else { return }
                
                for dic in jsonArray{
                    self.products.append(Product(dic))
                }
                DispatchQueue.main.async(execute:{
                    self.delegate?.updateUI()
                })
                
            } catch let parsingError{
                print("Error", parsingError)
            }
            
        }
        task.resume()
    }
    
    func addItem(_ name:String, _ type:String, _ price:Double, _ date:Date) {
        itemViewModel.addItem(name, "Shopping", price, Date())
    }
}
