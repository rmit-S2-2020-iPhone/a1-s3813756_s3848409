//
//  ViewController.swift
//  Assignment1
//
//  Created by Phearith on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource {

    
    
    //project variables
    var items = [Item]()
    var object:NSManagedObjectContext!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var selectedType = ""
    var sumItem: [Item] = []
    var amount:String?
    
    
    //profile scene
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var moreProfileButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    //stat scene
    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    let goals = [6, 8, 26, 30, 8, 10]
    
    @IBOutlet weak var statChart: PieChartView!
    @IBOutlet weak var statMoreButton: UIButton!
    @IBOutlet weak var statRemaining: UILabel!
    @IBOutlet weak var statThisMonth: UILabel!
    @IBOutlet weak var statLastMonth: UILabel!
    @IBOutlet weak var statGoal: UILabel!
    

    //home scene
    @IBOutlet weak var todayExpense: UILabel!
    @IBOutlet weak var homeMoreButton: UIButton!
    @IBOutlet weak var homeSegmentControl: UISegmentedControl!
    @IBOutlet weak var homeTableView: UITableView!
    
    
    //add scene
    let expenseType = ["Foods","Shopping","Rent","Services","Others"]
    
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var expenseTypePicker: UIPickerView!
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        saveItem()
    }
    @IBOutlet weak var itemNote: UITextField!
    @IBOutlet weak var itemDate: UIDatePicker!
    
    
    
    //setting scene
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        object = appDelegate?.persistentContainer.viewContext
        self.homeTableView?.dataSource = self
        loadData()
        totalSum()
        
        //profile scene
        userImage?.layer.borderWidth = 1
        userImage?.layer.masksToBounds = false
        userImage?.layer.borderColor = UIColor.black.cgColor
        userImage?.layer.cornerRadius = (userImage?.frame.height)!/2
        userImage?.clipsToBounds = true
        
        
        //add scene
        expenseTypePicker?.delegate = self
        expenseTypePicker?.dataSource = self
        
        
        //stat scene
        customizeChart(dataPoints: players, values: goals.map{Double($0)})
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
        totalSum()
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
        selectedType = String(expenseType[row])
    }
    
    
    
    //save function
    func saveItem() {
        let item = Item(context: object)
        let num :Double = (itemPrice.text! as NSString).doubleValue
        let priceField = Double(num)
        
        
        item.price = priceField
        item.name = itemNote.text
        item.date = itemDate.date
        
        if (selectedType == "Foods") {
            item.type = "Foods"
        }else if (selectedType == "Services") {
            item.type = "Services"
        }else if (selectedType == "Utilities") {
            item.type = "Utilities"
        }else if (selectedType == "Rent") {
            item.type = "Rent"
        }else if (selectedType == "Groceries") {
            item.type = "Groceries"
        }else{
            item.type = "Others"
        }
        appDelegate?.saveContext()
        
        loadData()
    }
    
    
    
    
    
    
    //////////////////stat scene//////////////////
    
    
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
    
    
    
    func totalSum() -> Void {
        do{
            sumItem = try object.fetch(Item.fetchRequest())
            var total:Double = 0.00
            for i in 0 ..< sumItem.count {
                total += sumItem[i].price
            }
            amount = "- $" + (NSString(format: "%.2f", total as CVarArg) as String)
            todayExpense?.text = amount
        }
        catch{
            print("Fetching Failed")
        }
    }
    
//    func loadDataByType() {
//        let itemRequest:NSFetchRequest<Item> = Item.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "type", ascending: false)
//        itemRequest.sortDescriptors = [sortDescriptor]
//        do {
//            try items = object.fetch(itemRequest)
//
//        }catch {
//            print("Could not load data")
//        }
//
//
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
//        let predicate = NSPredicate(format: "type = %@", argumentArray: ["Rent"]) // Specify your condition here
//        // Or for integer value
//        // let predicate = NSPredicate(format: "age > %d", argumentArray: [10])
//
//        fetch.predicate = predicate
//
//        do {
//
//            let result = try object.fetch(fetch)
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "type") as! String)
//                print(data.value(forKey: "name") as! String)
//                print(data.value(forKey: "date") as! Date)
//            }
//        } catch {
//            print("Failed")
//        }
//    }
    
    @IBAction func homeSegmentChanged(_ sender: Any) {
        var type:String?
        switch homeSegmentControl.selectedSegmentIndex
        {
        case 0:
             type = "Foods"
        case 1:
            type = "Shopping"
        case 2:
            type = "Rent"
        case 3:
            type = "Services"
        case 4:
            type = "Others"
        default:
            break
        }
        
    }
    
    
    
    
    
    
    
    
    //table view set up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ homeTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    
    func tableView(_ homeTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:customHomeTableCell = self.homeTableView.dequeueReusableCell(withIdentifier: "cell") as! customHomeTableCell
        let tableItem = items[indexPath.row]
        let itemDate = tableItem.date as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy, hh:mm"
        cell.itemDate.text = dateFormatter.string(from: itemDate)
        cell.itemName.text = tableItem.name
        cell.itemPrice.text = "- $" + String(tableItem.price)

        
        return cell
    }
    
    func tableView(_ homeTableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ homeTableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let item = self.items[indexPath.row]
            self.object.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.items.remove(at: indexPath.row)
            homeTableView.deleteRows(at: [indexPath], with: .fade)
            totalSum()
        }

    }
    
    
    
    // load data to table
    func loadData() {
        let itemRequest:NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            
        }catch {
            print("Could not load data")
        }
        self.homeTableView?.reloadData()
    }
    

    
    
    
    
    
    
    
    
    //////////////////setting scene//////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    //////////////////others//////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Date {
    static func current() -> Date {
        let calendar = Calendar.current
        
        var components = calendar.dateComponents([.year, .month, .day], from: Date())
        components.hour = 00
        components.minute = 00
        components.second = 00
        
        return calendar.date(from: components)!
    }
}
