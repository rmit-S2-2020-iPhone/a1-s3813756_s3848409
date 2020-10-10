//
//  Currency.swift
//  Assignment1
//
//  Created by sokleng on 10/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation

struct Weather {
    let summary:String
    let icon: String
    let temperature:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let temperature = json["temperature"] as? Double else {throw SerializationError.missing("temp is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    static let baseURL = "https://api.darksky.net/forecast/f7637fb1ae0905273b364af0e27ee1aa/"
    
    static func forecast(withLocation location:String, completion: @escaping([Weather]) -> ()){
        let url = baseURL + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request){ (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]{
                        if let dailyForecasts = json["hourly"] as? [String:Any]{
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]]{
                                for dataPoint in dailyData{
                                    if let weatherObject = try? Weather(json: dataPoint){
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
            
        }
        task.resume()
    }
    
}
