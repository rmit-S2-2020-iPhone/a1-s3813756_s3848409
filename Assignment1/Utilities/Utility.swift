//
//  util.swift
//  Assignment1
//
//  Created by Phearith & Sokleng on 31/8/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    func dateFormatter(itemDate:Date) -> String {
        let dateFormatter = DateFormatter()
        var result:String
        dateFormatter.amSymbol = "AM"                                   //declare date format for table item
        dateFormatter.pmSymbol = "PM"
        
        let calendar = Calendar.current
        if calendar.isDateInYesterday(itemDate) {
            dateFormatter.dateFormat = "h:mm a"                                                 //if the item is from yesterday, set it to yesterday format
            result = "Yesterday at " + dateFormatter.string(from: itemDate)
        }else if calendar.isDateInToday(itemDate) {
            dateFormatter.dateFormat = "h:mm a"
            result = "Today at " + dateFormatter.string(from: itemDate)
        }else if calendar.isDateInTomorrow(itemDate) {                                          //if the item is today, set it to today format
            dateFormatter.dateFormat = "h:mm a"
            result = "Tomorrow at " + dateFormatter.string(from: itemDate)
        }else{
            dateFormatter.dateFormat = "d-MM-yyyy, h:mm a"                                      //if the item is for tommorrow, set it to tommorrow format
            result = dateFormatter.string(from: itemDate)
        }
        return result
    }
}


extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}



extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var startOfMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfLastMonth: Date {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return  calendar.date(from: components)!
    }
    
    var startOfLastMonth: Date {
        return Calendar.current.date(byAdding: .day, value: -30, to: endOfLastMonth)!
    }
}


extension UIViewController {
    func popUpAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }                                                                               //general pop up alert function for the app
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
