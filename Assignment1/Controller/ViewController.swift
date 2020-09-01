//
//  ViewController.swift
//  Assignment1
//
//  Created by Phearith & Sokleng on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import Charts
import Foundation


//project variables
var globalItem:[itemModel] = []
var sortedItem:[itemModel] = []
var sumItem: [itemModel] = []
var selectedType:String?
var pickedType:String?
var amount:String?





class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource , UITextFieldDelegate{
    
    
    //profile scene
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var moreProfileButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    

    
    //stat scene
    var statType = [String]()
    var statValue = [Double]()
    
    
    @IBOutlet weak var statChart: PieChartView!
    @IBOutlet weak var statMoreButton: UIButton!
    @IBOutlet weak var statRemaining: UILabel!
    @IBOutlet weak var statThisMonth: UILabel!
    @IBOutlet weak var statLastMonth: UILabel!
    @IBOutlet weak var statGoal: UILabel!
    
    
    

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
            selectedType = "Foods"
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
    
    
    
    //add scene

    
    let expenseType = ["Foods","Shopping","Services","Others"]
    @IBOutlet weak var expenseTypePickerField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    let expenseTypePicker = UIPickerView()
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        addNewItem()
    }
    @IBOutlet weak var itemNote: UITextField!
    @IBOutlet weak var itemDate: UIDatePicker!
    
    
    
    
    //setting scene
    
    
    
    
    
    
    
    
    //viewDidLoad function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //home scene
        _ = createData
        sortData()
        totalSum()
        self.homeTableView?.dataSource = self
        
        
        //profile scene
        userImage?.layer.borderWidth = 1
        userImage?.layer.masksToBounds = false
        userImage?.layer.borderColor = UIColor.black.cgColor
        userImage?.layer.cornerRadius = (userImage?.frame.height)!/2
        userImage?.clipsToBounds = true
        
        
        //add scene
        addDoneButton()
        
        expenseTypePickerField?.inputView = expenseTypePicker
        expenseTypePicker.delegate = self
        expenseTypePicker.dataSource = self
        
        
        
        //stat scene
        getChartData()
        customizeChart(dataPoints: statType, values: statValue.map{Double($0)})
        
        
    }

    
    //viewDidAppear function
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sortData()
        totalSum()
    }
    
    //message dialog
    func popUpAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    //////////////////add scene//////////////////
    
    
    
    //picker view
    func numberOfComponents(in expenseTypePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ expenseTypePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseType.count
    }
    
    func pickerView(_ expenseTypePicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseType[row]
    }
    
    func pickerView(_ expenseTypePicker: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        expenseTypePickerField.text = expenseType[row]
        pickedType = String(expenseType[row])
    }

    
    func addDoneButton() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1)
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneAction))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        expenseTypePickerField?.inputAccessoryView = toolBar
    }
    
    
    
    // add new item function
    
    func addNewItem() {
        
        let num :Double = (itemPrice.text! as NSString).doubleValue
        let newItemName:String? = itemNote.text
        let newItemPrice = Double(num)
        let newItemDate = itemDate.date
        var newItemType:String?
        
        if (pickedType == "Foods") {
            newItemType = "Foods"
        }else if (pickedType == "Shopping") {
            newItemType = "Shopping"
        }else if (pickedType == "Services") {
            newItemType = "Services"
        }else if (pickedType == "Others"){
            newItemType = "Others"
        }
        
        if (newItemName?.trim() == "" ){
            popUpAlert(withTitle: "Error", message: "Please add a note for this item")
        }else if (newItemPrice <= 0) {
            popUpAlert(withTitle: "Error", message: "Please add a value for this item")
        }else if (newItemType?.trim() == nil) {
            popUpAlert(withTitle: "Error", message: "Please choose a type for this item")
        }
        else {
            globalItem.insert(itemModel(name: newItemName!, type: newItemType!, price: newItemPrice, date: newItemDate), at:0)
            sortData()
        }
    }
    
    
    //close picker view
    @objc func doneAction() {
        expenseTypePickerField.resignFirstResponder()
    }
    
    
    
    
    
    //////////////////stat scene//////////////////
    
    
    
    func getChartData() {
        sumItem = sortedItem
        if sumItem.count > 0 {
            for i in 0 ..< sumItem.count {
                statType.append(sumItem[i].type)
                statValue.append(sumItem[i].price)
            }
        }else {
            todayExpense?.text = "No expense yet"
        }
    }
    
    
    func customizeChart(dataPoints: [String], values: [Double]) {
        
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data:  dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: nil)
        pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataPoints.count)
        
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // 4. Assign it to the chart's data
        statChart?.noDataText = "No data available"
        statChart?.centerText = "Overall expenses"
        let d = Description()
        d.text = "Total Expenses in Pie Chart"
        statChart?.chartDescription? = d
        statChart?.data = pieChartData
    }
    
    private func colorsOfCharts(numbersOfColor: Int) -> [UIColor] {
        var colors: [UIColor] = []
        for _ in 0..<numbersOfColor {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        return colors
    }
    
    
    
    
    
    
    
    
    //////////////////profile scene//////////////////
    
    

    
    
    
    
    
    //////////////////home scene//////////////////
    
    
    
    private lazy var createData: Void = {
        if globalItem.count == 0 {
            let date = Date()
            globalItem.insert(itemModel(name: "Clothes", type: "Shopping", price: 110.7, date: date), at: 0)
            globalItem.insert(itemModel(name: "Electricity", type: "Services", price: 150.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Shoes", type: "Shopping", price: 212.90, date: date), at: 0)
            globalItem.insert(itemModel(name: "Lobster", type: "Foods", price: 50.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Car service", type: "Services", price: 512.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "House Rent", type: "Services", price: 1200.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Lend Money", type: "Others", price: 100.0, date: date), at: 0)
            sortedItem = globalItem
        }
    }()
    
    
    
    func getCategory(type:String) -> Array<itemModel> {
        let item:[itemModel] = []
        return item
    }
    
    func sortData() {
        if selectedType == "All" {
            sortedItem = globalItem
        }else if selectedType == "Foods" {
            sortedItem = globalItem.filter { $0.type.contains("Foods") }
        }else if selectedType == "Shopping" {
            sortedItem = globalItem.filter { $0.type.contains("Shopping") }
        }else if selectedType == "Services" {
            sortedItem = globalItem.filter { $0.type.contains("Services") }
        }else if selectedType == "Others" {
            sortedItem = globalItem.filter { $0.type.contains("Others") }
        }
        loadData()
    }
    
    
    
    
    
    // load data to table and sort
    func loadData() {
        sortedItem.sort(by: {$0.date > $1.date})
        self.homeTableView?.reloadData()
    }
    
    
    //total expense label
    
    func totalSum() -> Void {
        sumItem = sortedItem
        if sumItem.count > 0 {
            var total:Double = 0.00
            for i in 0 ..< sumItem.count {
                total += sumItem[i].price
            }
            amount = "- $" + (NSString(format: "%.2f", total as CVarArg) as String)
            todayExpense?.text = amount
        }
        else {
            todayExpense?.text = "No expense yet"
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
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let calendar = Calendar.current
        if calendar.isDateInYesterday(itemDate) {
            dateFormatter.dateFormat = "h:mm a"
            cell.itemDate.text = "Yesterday at " + dateFormatter.string(from: itemDate)
        }else if calendar.isDateInToday(itemDate) {
            dateFormatter.dateFormat = "h:mm a"
            cell.itemDate.text = "Today at " + dateFormatter.string(from: itemDate)
        }else if calendar.isDateInTomorrow(itemDate) {
            dateFormatter.dateFormat = "h:mm a"
            cell.itemDate.text = "Tomorrow at " + dateFormatter.string(from: itemDate)
        }else{
            dateFormatter.dateFormat = "d-MM-yyyy, h:mm a"
            cell.itemDate.text = dateFormatter.string(from: itemDate)
        }
        cell.itemName.text = tableItem.name
        cell.itemPrice.text = "- $" + String(tableItem.price)

        
        return cell
    }
    
    func tableView(_ homeTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ homeTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            sortedItem.remove(at: indexPath.row)
            homeTableView.deleteRows(at: [indexPath], with: .fade)
            globalItem = sortedItem
            sortData()
            totalSum()
        }
    }
    
    


    
    
    
    
    
    //////////////////setting scene//////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    //////////////////others//////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

