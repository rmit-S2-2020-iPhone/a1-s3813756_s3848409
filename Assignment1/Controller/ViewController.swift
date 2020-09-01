//
//  ViewController.swift
//  Assignment1
//
//  Created by Phearith on 31/7/20.
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
var budget = 1000.0




class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    //profile scene
    
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet var profileOptions: [UIButton]!
    @IBAction func editProfile(_ sender: UIButton) {
        profileOptions.forEach {(button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
                button.layer.cornerRadius = 4
                button.backgroundColor? = UIColor.white
            })
        }
    }
    @IBAction func editUserName(_ sender: UIButton) {
        editName()
    }
    @IBAction func editProfilePic(_ sender: UIButton) {
        editUserPic()
    }
    @IBAction func changeBudgetBtn(_ sender: Any) {
        changeBudget()
    }
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    
    
    
    
    @IBOutlet var profileSumView: [UIView]!
    @IBOutlet weak var thisMonthExpense: UILabel!
    @IBOutlet weak var monthBudget: UILabel!
    @IBOutlet weak var remainingBudget: UILabel!
    
    

    
    
    
    //stat scene
    
    var statType = [String]()
    var statValue = [Double]()
    
    
    @IBOutlet weak var statChart: PieChartView!
    @IBOutlet weak var statMoreButton: UIButton!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var avgMonthLabel: UILabel!
    @IBOutlet weak var lastMonthExpenseLabel: UILabel!
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
        self.homeTableView?.dataSource = self
        
        
        //profile scene
        setProfilePic()
        
        
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
        setProfilePic()
        
    }
    
    
    
    //message dialog
    func popUpAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // load data to table and sort
    func loadData() {
        sortedItem.sort(by: {$0.date > $1.date})
        todayExp()
        thisMonthExp()
        totalExp()
        self.homeTableView?.reloadData()
        profileSumView?.forEach {(view) in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                view.layer.cornerRadius = 10
            })
        }
        itemPrice?.keyboardType = .decimalPad
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
        toolBar.tintColor = UIColor.blue
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneAction))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        expenseTypePickerField?.inputAccessoryView = toolBar
        itemPrice?.inputAccessoryView = toolBar
        itemNote?.inputAccessoryView = toolBar
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
        itemPrice.resignFirstResponder()
        itemNote.resignFirstResponder()
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
    
    
    func totalExp() {
        let totalItem = globalItem
        if totalItem.count > 0 {
            var totalExpense:Double = 0.00
            for i in 0 ..< sumItem.count {
                totalExpense += sumItem[i].price
            }
            let totalAmount = String(format: "$%.02f", totalExpense as CVarArg)
            totalExpenseLabel?.text = totalAmount
        }
        else {
            thisMonthExpense?.text = "No expense yet"
        }
    }
    
    
    
    
    
    
    
    //////////////////profile scene//////////////////
    
    
    //set user profile picture function
    var imagePicker = UIImagePickerController()
    
    func editUserPic() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        userImage?.image = image
    }
    
    
    
    
    //set up user profile layout
    
    func setProfilePic() {
        userImage?.layer.borderWidth = 2
        userImage?.backgroundColor = UIColor.white
        userImage?.layer.masksToBounds = false
        userImage?.layer.borderColor = UIColor.black.cgColor
        userImage?.layer.cornerRadius = (userImage?.frame.height)!/2
        userImage?.clipsToBounds = true
    }
    
    
    //edit user name
    func editName() {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.userName?.text = alert.textFields?.first?.text
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    func thisMonthExp() {
        sumItem = globalItem
        let today = Date()
        let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        let monthRange = thirtyDaysBeforeToday...today
        
        if sumItem.count > 0 {
            var monthExpense:Double = 0.00
            for i in 0 ..< sumItem.count {
                if monthRange.contains(sumItem[i].date){
                    monthExpense += sumItem[i].price
                }
            }
            let monthAmount = String(format: "$%.02f", monthExpense as CVarArg)
            let remainBudget = String(format: "$%.02f", budget - monthExpense as CVarArg)
            remainingBudget?.text = remainBudget
            thisMonthExpense?.text = monthAmount
            monthBudget?.text = "$" + String(budget)
        }
        else {
            thisMonthExpense?.text = "No expense yet"
        }
    }
    
    func changeBudget() {
        let alert = UIAlertController(title: "Please enter your budget below", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your budget here..."
            textField.keyboardType = .decimalPad
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let strCheck = alert.textFields?.first?.text
            if (strCheck?.trim() == "" || strCheck?.trim() == "." || strCheck?.trim() == ".." ){
                self.popUpAlert(withTitle: "Error", message: "Please enter a value.")
            }else{
                let newBudget = strCheck?.toDouble()
                self.monthBudget?.text = String(format: "$%.02f", newBudget as! CVarArg)
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
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
    
    
    
    
    
    
    
    
    
    //this month expense function
    
    func todayExp() -> Void {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let monthRange = yesterday...today
        sumItem = globalItem
        if sumItem.count > 0 {
            var total:Double = 0.00
            for i in 0 ..< sumItem.count {
                if monthRange.contains(sumItem[i].date){
                    total += sumItem[i].price
                }
            }
            let totalAmount = "- $" + (NSString(format: "%.2f", total as CVarArg) as String)
            todayExpense?.text = totalAmount
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
        }
    }
    
    


    
    
    
    
    
    //////////////////setting scene//////////////////
    
    
    
    
    
    
    
    
    
    
    
    
    
    //////////////////others//////////////////
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

