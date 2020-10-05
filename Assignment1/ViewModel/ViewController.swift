//
//  ViewController.swift
//  Assignment1
//
//  Created by Phearith & Sokleng on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import Foundation

var selectedType:String?            // declare important variables for the project
var pickedType:String?


class ViewController: UIViewController, UITableViewDataSource, UIActionSheetDelegate{

    //home scene
    var util = Util()
    
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
    
    @IBOutlet weak var itemDetailImage: UIImageView!
    @IBOutlet weak var itemDetailPrice: UITextField!
    @IBOutlet weak var itemDetailName: UITextField!
    @IBOutlet weak var itemDetailType: UITextField!
    @IBOutlet weak var itemDetailDate: UITextField!
    @IBAction func changeDetail(_ sender: Any) {
        
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
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destination = segue.destination as? ItemDetailViewController
//        let indexPath = IndexPath(row: 0, section: 0)
//        let cell = homeTableView.cellForRow(at: indexPath) as! customHomeTableCell
//        destination?.detailName = cell.itemName.text
//        destination?.detailPrice = cell.itemPrice.text
//        destination?.detailDate = cell.itemDate.text
//    }
    
    
    
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
        sortedItem.sort(by: {$0.itemDate > $1.itemDate})                        //load data by date descending
        todayExp()
        
        self.homeTableView?.reloadData()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
    }

    
    //////////////////home scene//////////////////
    
    
    
    private lazy var createData: Void = {
        if globalItem.count == 0 {                                                                  //mock up database when the app starts
            let date = Date()
            globalItem.insert(ItemModel(itemName: "Clothes", itemType: "Shopping", itemPrice: 110.7, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Electricity", itemType: "Services", itemPrice: 150.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Shoes", itemType: "Shopping", itemPrice: 212.90, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Lobster", itemType: "Foods", itemPrice: 89.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Car service", itemType: "Services", itemPrice: 112.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "KFC", itemType: "Foods", itemPrice: 20.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Lend Money", itemType: "Others", itemPrice: 100.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "House Rent", itemType: "Services", itemPrice: 400.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Red Cross Donation", itemType: "Others", itemPrice: 50.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Groceries", itemType: "Shopping", itemPrice: 89.0, itemDate: date), at: 0)
            globalItem.insert(ItemModel(itemName: "Chinese Takeout", itemType: "Foods", itemPrice: 60.0, itemDate: date), at: 0)
            sortedItem = globalItem
        }
    }()
    
    
    

    
    
    //sort data for table
    func sortData() {
        if selectedType == "All" {
            sortedItem = globalItem                                                     //sort the items to each type for display on home page
        }else if selectedType == "Foods" {
            sortedItem = globalItem.filter { $0.itemType.contains("Foods") }
        }else if selectedType == "Shopping" {
            sortedItem = globalItem.filter { $0.itemType.contains("Shopping") }
        }else if selectedType == "Services" {
            sortedItem = globalItem.filter { $0.itemType.contains("Services") }
        }else if selectedType == "Others" {
            sortedItem = globalItem.filter { $0.itemType.contains("Others") }
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
                if todayRange.contains(sumItem[i].itemDate){
                    total += sumItem[i].itemPrice
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
        let itemDate = tableItem.itemDate as Date
        cell.itemDate.text = util.dateFormatter(itemDate: itemDate)
        cell.itemName.text = tableItem.itemName
        cell.itemPrice.text = "- $" + String(tableItem.itemPrice)
        if tableItem.itemType == "Foods" {
            cell.itemImage.image = UIImage(named:ItemCategory.food.rawValue)
        }else if tableItem.itemType == "Shopping" {
            cell.itemImage.image = UIImage(named:ItemCategory.shopping.rawValue)
        }else if tableItem.itemType == "Services" {
            cell.itemImage.image = UIImage(named:ItemCategory.service.rawValue)
        }else if tableItem.itemType == "Others" {
            cell.itemImage.image = UIImage(named:ItemCategory.others.rawValue)
        }
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
