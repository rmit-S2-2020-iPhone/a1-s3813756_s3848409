//
//  Currency.swift
//  Assignment1
//
//  Created by sokleng on 10/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct Currency {
    let currency:String
    let rate: Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let currency = json["currency"] as? String else {throw SerializationError.missing("base is missing")}
        guard let rate = json["rate"] as? Double else {throw SerializationError.missing("rate is missing")}
        self.currency = currency
        self.rate = rate
    }
    
    static let baseURL = "http://data.fixer.io/api/latest?access_key=e8b6e5a1b3996efaabb8e3a32aafed07"
    
    static func rateExchange(completion: @escaping([Currency]) -> ()){
        
        let request = URLRequest(url: URL(string: baseURL)!)
        
        let task = URLSession.shared.dataTask(with: request){ (data:Data?, response:URLResponse?, error:Error?) in
            
            var currencyArray:[Currency] = []
            
            if let data = data {
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        if let rate = json["rates"] as? [[String:Any]]{
                            for dataPoint in rate {
                                if let rateObject = try? Currency(json: dataPoint){
                                    currencyArray.append(rateObject)
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                completion(currencyArray)
            }
            
        }
        task.resume()
    }
    
}
