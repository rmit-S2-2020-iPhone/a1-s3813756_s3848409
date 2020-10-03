//
//  ViewController.swift
//  Assignment1
//
//  Created by Phearith & Sokleng on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import Foundation

//project variables
var globalItem:[ItemModel] = []
var sortedItem:[ItemModel] = []
var sumItem: [ItemModel] = []
var selectedType:String?            // declare important variables for the project
var pickedType:String?
var budget = 2000.0


class ViewController: UIViewController, UITableViewDataSource, UIActionSheetDelegate{

    //home scene
    @IBOutlet weak var todayExpense: UILabel!
    @IBOutlet weak var homeSegmentControl: UISegmentedControl!
    @IBOutlet weak var homeTableView: UITableView!
    @IBAction func homeSegmentChanged(_ sender: Any) {
        
        switch homeSegmentControl.selectedSegmentIndex
        {
        case 0:
            selectedType = "All"
            sortData()
        case 1:
            selectedType = "Foods"                              //home segment control action when tab switched
            sortData()
        case 2:
            selectedType = "Shopping"
            sortData()
        case 3:
            selectedType = "Services"
            sortData()
        case 4:
            selectedType = "Others"
            sortData()
        default:
            break
        }
        
    }

    
    //viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //home scene
        _ = createData                                              //mock data to table once after the app started running
        sortData()                                                  //sort the data for the table in home page
        self.homeTableView?.dataSource = self                       //set datasource for home table view
        
    }

    
    //viewDidAppear function
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sortData()
                                                //call neccessary function that needs to be updated
    }
    
    
    
    //////////////////Miscellaneous//////////////////
    
    
    //message dialog
    func popUpAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }                                                                               //general pop up alert function for the app
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
 
    
    // load data to table and sort
    func loadData() {
        sortedItem.sort(by: {$0.date > $1.date})                        //load data by date descending
        todayExp()
        
        self.homeTableView?.reloadData()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }

    
    //////////////////home scene//////////////////
    
    
    
    private lazy var createData: Void = {
        if globalItem.count == 0 {                                                                  //mock up database when the app starts
            let date = Date()
            globalItem.insert(ItemModel(name: "Clothes", type: "Shopping", price: 110.7, date: date), at: 0)
            globalItem.insert(ItemModel(name: "Electricity", type: "Services", price: 150.0, date: date), at: 0)
            globalItem.insert(ItemModel(name: "Shoes", type: "Shopping", price: 212.90, date: date), at: 0)
            globalItem.insert(ItemModel(name: "Lobster", type: "Foods", price: 89.0, date: date), at: 0)
            globalItem.insert(ItemModel(name: "KFC", type: "Foods", price: 20.0, date: date), at: 0)
            globalItem.insert(ItemModel(name: "Car service", type: "Services", price: 112.0, date: date), at: 0)
            globalItem.insert(ItemModel(name: "House Rent", type: "Services", price: 400.0, date: date), at: 0)
            globalItem.insert(ItemModel(name: "Lend Money", type: "Others", price: 100.0, date: date), at: 0)
            globalItem.insert(ItemModel(name: "Red Cross Donation", type: "Others", price: 50.0, date: date), at: 0)
            sortedItem = globalItem
        }
    }()
    
    
    
    func getCategory(type:String) -> Array<ItemModel> {
        let item:[ItemModel] = []
        return item
    }
    
    
    //sort data for table
    func sortData() {
        if selectedType == "All" {
            sortedItem = globalItem                                                     //sort the items to each type for display on home page
        }else if selectedType == "Foods" {
            sortedItem = globalItem.filter { $0.type.contains("Foods") }
        }else if selectedType == "Shopping" {
            sortedItem = globalItem.filter { $0.type.contains("Shopping") }
        }else if selectedType == "Services" {
            sortedItem = globalItem.filter { $0.type.contains("Services") }
        }else if selectedType == "Others" {
            sortedItem = globalItem.filter { $0.type.contains("Others") }
        }
        loadData()                                                                      //reload the items to table
    }
    
    
    //this month expense function
    func todayExp() -> Void {
        let todayRange = Date().startOfDay...Date().endOfDay     //set today's range
        sumItem = globalItem
        if sumItem.count > 0 {
            var total:Double = 0.00
            for i in 0 ..< sumItem.count {                                                      //calculate today's expense
                if todayRange.contains(sumItem[i].date){
                    total += sumItem[i].price
                }
            }
            let totalAmount = "- $" + (NSString(format: "%.2f", total as CVarArg) as String)
            todayExpense?.text = totalAmount                                                     //set the value to homepage label
        }
        else {
            todayExpense?.font = UIFont(name: "Gills Sans", size: 14)
            todayExpense?.text = "No Expense Yet"                                                 //exception if no data found
        }
    }
    
    
    //table view set up for home scene
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ homeTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedItem.count

    }
    
    func tableView(_ homeTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:customHomeTableCell = self.homeTableView.dequeueReusableCell(withIdentifier: "cell") as! customHomeTableCell
        let tableItem = sortedItem[indexPath.row]
        let itemDate = tableItem.date as Date
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"                                   //declare date format for table item
        dateFormatter.pmSymbol = "PM"
        
        let calendar = Calendar.current
        if calendar.isDateInYesterday(itemDate) {
            dateFormatter.dateFormat = "h:mm a"                                                 //if the item is from yesterday, set it to yesterday format
            cell.itemDate.text = "Yesterday at " + dateFormatter.string(from: itemDate)
        }else if calendar.isDateInToday(itemDate) {
            dateFormatter.dateFormat = "h:mm a"
            cell.itemDate.text = "Today at " + dateFormatter.string(from: itemDate)
        }else if calendar.isDateInTomorrow(itemDate) {                                          //if the item is today, set it to today format
            dateFormatter.dateFormat = "h:mm a"
            cell.itemDate.text = "Tomorrow at " + dateFormatter.string(from: itemDate)
        }else{
            dateFormatter.dateFormat = "d-MM-yyyy, h:mm a"                                      //if the item is for tommorrow, set it to tommorrow format
            cell.itemDate.text = dateFormatter.string(from: itemDate)
        }
        cell.itemName.text = tableItem.name
        cell.itemPrice.text = "- $" + String(tableItem.price)                                   //set the item name and price to table

        
        return cell
    }
    
    func tableView(_ homeTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //delete function for table
    func tableView(_ homeTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            sortedItem.remove(at: indexPath.row)                                                        //remove item from table
            homeTableView.deleteRows(at: [indexPath], with: .fade)
            globalItem = sortedItem
            sortData()                                                                                  //reload data
            popUpAlert(withTitle: "Item Deleted", message: "Item successfully deleted!")                //successful delete pop up message
        }
    }
    

    
    //////////////////others//////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
