//
//  ViewController.swift
//  Assignment1
//
//  Created by Phearith & Sokleng on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import Foundation




class ViewController: UIViewController, UITableViewDataSource, UIActionSheetDelegate{

    //home scene
    var selectedType:String = ""            // declare important variables for the project
    private var itemViewModel = ItemViewModel()
    
    @IBOutlet weak var todayExpense: UILabel!
    @IBOutlet weak var homeSegmentControl: UISegmentedControl!
    @IBOutlet weak var homeTableView: UITableView!
    @IBAction func homeSegmentChanged(_ sender: Any) {
        
        switch homeSegmentControl.selectedSegmentIndex
        {
        case 0:
            selectedType = "All"
            itemViewModel.sortItems(selectedType)
            self.homeTableView?.reloadData()
        case 1:
            selectedType = "Foods"                              //home segment control action when tab switched
            itemViewModel.sortItems(selectedType)
            self.homeTableView?.reloadData()
        case 2:
            selectedType = "Shopping"
            itemViewModel.sortItems(selectedType)
            self.homeTableView?.reloadData()
        case 3:
            selectedType = "Services"
            itemViewModel.sortItems(selectedType)
            self.homeTableView?.reloadData()
        case 4:
            selectedType = "Others"
            itemViewModel.sortItems(selectedType)
            self.homeTableView?.reloadData()
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
        itemViewModel.sortItems(selectedType)                                                  //sort the data for the table in home page
        self.homeTableView?.dataSource = self                       //set datasource for home table view
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }

    
    //viewDidAppear function
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        itemViewModel.sortItems(selectedType)
        self.homeTableView?.reloadData()
    }
    
    
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
    

    
    //this month expense function
    func todayExp() -> Void {
        let todayRange = Date().startOfDay...Date().endOfDay     //set today's range
        sumItem = globalItem
        if sumItem.count > 0 {
            var total:Double = 0.00
            for i in 0 ..< sumItem.count {                                                      //calculate today's expense
                if todayRange.contains(sumItem[i].date!){
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
        let itemDate = tableItem.date as! Date
        cell.itemDate.text = dateFormatter(itemDate: itemDate)
        cell.itemName.text = tableItem.name
        cell.itemPrice.text = "- $" + String(tableItem.price)
        if tableItem.type == "Foods" {
            cell.itemImage.image = UIImage(named:ItemCategory.food.rawValue)
        }else if tableItem.type == "Shopping" {
            cell.itemImage.image = UIImage(named:ItemCategory.shopping.rawValue)
        }else if tableItem.type == "Services" {
            cell.itemImage.image = UIImage(named:ItemCategory.service.rawValue)
        }else if tableItem.type == "Others" {
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
            let deleteItem = sortedItem[indexPath.row]
            itemViewModel.deleteItems(deleteItem)
            sortedItem.remove(at: indexPath.row)
            self.homeTableView?.deleteRows(at: [indexPath], with: .fade)
            itemViewModel.sortItems(selectedType)                                                                                  //reload data
            self.popUpAlert(withTitle: "Item Deleted", message: "Item successfully deleted!")                //successful delete pop up message
        }
    }
    
    
    
    //////////////////others//////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
