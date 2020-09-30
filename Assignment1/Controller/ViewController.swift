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
var selectedType:String?            // declare important variables for the project
var pickedType:String?
var budget = 2000.0




class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource , UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    //profile scene
    @IBOutlet weak var userImage: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet var profileOptions: [UIButton]!
    @IBAction func editProfile(_ sender: UIButton) {
        profileOptions.forEach {(button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()                      //show the buttons stack when user click edit on profile page
                button.layer.cornerRadius = 4
                button.backgroundColor? = UIColor.white
            })
        }
    }
    @IBAction func editUserName(_ sender: UIButton) {
        editName()                                              //call edit name function when user click edit name button
    }
    @IBAction func editProfilePic(_ sender: UIButton) {
        editUserPic()                                           //call edit user picture function when user click choose profile image
    }
    @IBAction func changeBudgetBtn(_ sender: Any) {
        changeBudget()                                          //call change budget function if user click change budget on profile page
    }
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?                       //declare necessary controller for choosing image process
    var pickImageCallback : ((UIImage) -> ())?;

    
    @IBOutlet var profileSumView: [UIView]!
    @IBOutlet weak var thisMonthExpense: UILabel!
    @IBOutlet weak var monthBudget: UILabel!
    @IBOutlet weak var remainingBudget: UILabel!
    
    
    //stat scene
    let statType : [String] = ["Foods", "Services", "Shopping", "Others"]
    var statValue : [Double] = [0.0, 0.0, 0.0, 0.0]
    var totalFoods : Double = 0.0
    var totalServices : Double = 0.0                            //declare required variables for statistics scene pie chart
    var totalShop : Double = 0.0
    var totalOthers : Double = 0.0
    var foodsPerc : Double = 0.0
    var servicesPerc : Double = 0.0
    var shoppingsPerc : Double = 0.0                            //to calculate percentage for the pie chart
    var othersPerc : Double = 0.0
    
    
    @IBOutlet weak var statChart: PieChartView!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var avgDayLabel: UILabel!
    @IBOutlet weak var lastMonthExpenseLabel: UILabel!
    @IBOutlet weak var biggestSpentLabel: UILabel!
    

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

    
    //add scene
    let expenseType = ["Foods","Shopping","Services","Others"]
    @IBOutlet weak var expenseTypePickerField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    let expenseTypePicker = UIPickerView()
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        addNewItem()                                                //addnewitem function will be called after user click "add" button
    }
    @IBOutlet weak var itemNote: UITextField!
    @IBOutlet weak var itemDate: UIDatePicker!
    
    
    
    //viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //home scene
        _ = createData                                              //mock data to table once after the app started running
        sortData()                                                  //sort the data for the table in home page
        self.homeTableView?.dataSource = self                       //set datasource for home table view
        
        
        //profile scene
        setProfilePic()                                             //set profile pic layout and initial user image
        
        
        //add scene
        addDoneButton()                                             //add toolbar with done button for app keyboard
        expenseTypePickerField?.inputView = expenseTypePicker       //initialise expense type picker field
        expenseTypePicker.delegate = self                           //set source for expense type picker
        expenseTypePicker.dataSource = self
        
        
        //stat scene
        getChartData()                                              //get chart data and initialise pie chart for stat scene
    }

    
    //viewDidAppear function
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sortData()
        setProfilePic()                                             //call neccessary function that needs to be updated
        getChartData()                                              //when the user switch tabs
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
    
    
    //add toolbar to app keyboard
    func addDoneButton() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.blue                                                //keyboard toolbar function
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneAction))
        toolBar.setItems([flexibleSpace, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        expenseTypePickerField?.inputAccessoryView = toolBar
        itemPrice?.inputAccessoryView = toolBar                                         //set which textfield require a toolbox
        itemNote?.inputAccessoryView = toolBar
    }
    
    
    //close picker view
    @objc func doneAction() {
        expenseTypePickerField.resignFirstResponder()
        itemPrice.resignFirstResponder()                                                //will resign after user click done
        itemNote.resignFirstResponder()
    }
    
    
    // load data to table and sort
    func loadData() {
        sortedItem.sort(by: {$0.date > $1.date})                        //load data by date descending
        todayExp()
        thisMonthExp()
        lastMonthExp()                                                  //call today expense, this month, last month and total expense function
        totalExp()                                                      //to the app when it starts
        self.homeTableView?.reloadData()
        profileSumView?.forEach {(view) in
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()                              //set style for profile page
                view.layer.cornerRadius = 10
            })
        }
        itemPrice?.keyboardType = .decimalPad                           //set decimal keyboard for item price text field
    }
    
    
    
    
    //////////////////add scene//////////////////
    
    
    //picker view function
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
    
    
    // add new item function
    func addNewItem() {
        
        let num :Double = (itemPrice.text! as NSString).doubleValue
        let newItemName:String? = itemNote.text
        let newItemPrice = Double(num)                      //declare new item component to set new value in
        let newItemDate = itemDate.date
        var newItemType:String?
        
        if (pickedType == "Foods") {
            newItemType = "Foods"
        }else if (pickedType == "Shopping") {
            newItemType = "Shopping"
        }else if (pickedType == "Services") {               //if condition for expense type picker
            newItemType = "Services"
        }else if (pickedType == "Others"){
            newItemType = "Others"
        }
        
        if (newItemName?.trim() == "" ){
            popUpAlert(withTitle: "Error", message: "Please add a note for this item")
        }else if (newItemPrice <= 0) {                                                          //check for exception if user input incorrect value in textfield
            popUpAlert(withTitle: "Error", message: "Please add a value for this item")
        }else if (newItemType?.trim() == nil) {
            popUpAlert(withTitle: "Error", message: "Please choose a type for this item")
        }
        else {
            globalItem.insert(itemModel(name: newItemName!, type: newItemType!, price: newItemPrice, date: newItemDate), at:0)
            sortData()                                                                          //else add the new item to database and sort all data again
            popUpAlert(withTitle: "Item Added", message: "Item successfully added!")            //pop up success message
        }
    }
    

    
    
    //////////////////stat scene//////////////////
    
    // get data and assign to chart function
    func getChartData() {
        let totalItem = globalItem
        if totalItem.count > 0 {                                            //count if database exist
            totalFoods = statValue[0]
            totalServices = statValue[1]                                    //set value to array index
            totalShop = statValue[2]
            totalOthers = statValue[3]
            for i in 0 ..< totalItem.count {
                if sumItem[i].type == "Foods" {
                    totalFoods += totalItem[i].price
                } else if sumItem[i].type == "Services" {                   //sort data into each category
                    totalServices += totalItem[i].price
                } else if sumItem[i].type == "Shopping" {
                    totalShop += totalItem[i].price
                } else if sumItem[i].type == "Others" {
                    totalOthers += totalItem[i].price
                }
            }
            let totalAmount = totalFoods + totalServices + totalShop + totalOthers
            foodsPerc = totalFoods / totalAmount * 100
            servicesPerc = totalServices / totalAmount * 100                //calculate the item to get percentage for pie chart
            shoppingsPerc = totalShop / totalAmount * 100
            othersPerc = totalOthers / totalAmount * 100
            
            statValue.removeAll()
            statValue.append(foodsPerc)
            statValue.append(servicesPerc)                                  //set value to array
            statValue.append(shoppingsPerc)
            statValue.append(othersPerc)
            customizeChart(dataPoints: statType, values: statValue.map{Double($0)})       //trigger the chart with the ready value
        }else {
            print("No expense yet")
        }
    }
    
    
    //fill chart data and customise the chart
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
        format.numberStyle = .percent
        format.multiplier = 1.0
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
                                                                                        // 4. Assign it to the chart's data
        statChart?.noDataText = "No Data Available"
        statChart?.centerText = "Overall Expenses"
        let d = Description()
        d.text = "Total Expenses in Pie Chart"
        statChart?.chartDescription? = d
        statChart?.data = pieChartData
    }
    
    
    // random color for charts
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
    
    
    // total expense and avg expense function
    func totalExp() {
        let totalItem = globalItem
        if totalItem.count > 0 {                                                    //count if database exist
            var totalExpense:Double = 0.00
            for i in 0 ..< sumItem.count {
                totalExpense += sumItem[i].price                                    //calculate sum of all item price
            }
            let totalAmount = String(format: "$%.02f", totalExpense as CVarArg)
            totalExpenseLabel?.text = totalAmount                                   //set total expense text
            
            let avgAmount = String(format: "$%.02f", totalExpense/30 as CVarArg)    //calculate average amount
            avgDayLabel?.text = avgAmount                                           //and set it to average label
        }
        else {
            totalExpenseLabel?.text = "No Expense Yet"                              //exception if no database found
            avgDayLabel?.text = "No Average Found"
        }
    }
    
    
    
    //////////////////profile scene//////////////////
    
    
    //set user profile picture function
    var imagePicker = UIImagePickerController()
    
    func editUserPic() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum                              //call image picker when user click edit user image
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return                                                                  //get the image that user chose
        }
        userImage?.image = image                                                    //set the image after user picked the image
    }
    
    
    //set up user profile layout
    func setProfilePic() {
        userImage?.layer.borderWidth = 2
        userImage?.backgroundColor = UIColor.white
        userImage?.layer.masksToBounds = false                                      //set user image layout
        userImage?.layer.borderColor = UIColor.black.cgColor
        userImage?.layer.cornerRadius = (userImage?.frame.height)!/2
        userImage?.clipsToBounds = true
    }
    
    
    //edit user name
    func editName() {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))                   //call alert function when editname function is triggered
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."                                           //set a textfield for user input
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.userName?.text = alert.textFields?.first?.text                                         //set a button after finish editing
        }))
        
        self.present(alert, animated: true)
    }
    
    
    //calculate expense for this month
    func thisMonthExp() {
        sumItem = globalItem
               //find the end of current month
        let monthRange = Date().startOfMonth...Date().endOfMonth                                                  //define month range
        if sumItem.count > 0 {
            var monthExpense:Double = 0.00
            var biggestSpent:Double?
            for i in 0 ..< sumItem.count {
                if monthRange.contains(sumItem[i].date){                                            //find the sum of this month expense if database exist
                    monthExpense += sumItem[i].price
                    biggestSpent = sumItem.map{$0.price}.max()
                }
            }
            let monthAmount = String(format: "$%.02f", monthExpense as CVarArg)                     //calculate this month expense
            let remainBudget = String(format: "$%.02f", budget - monthExpense as CVarArg)           //calculate remaining budget base on user's current budget
            let bigSpent = String(format: "$%.02f", biggestSpent as! CVarArg)                       //find the biggest spent of the month
            biggestSpentLabel?.text = bigSpent
            remainingBudget?.text = remainBudget                                                    //set those values to label
            thisMonthExpense?.text = monthAmount
            monthBudget?.text = "$" + String(budget)
        }
        else {
            thisMonthExpense?.font = UIFont(name: "Gills Sans", size: 14)
            remainingBudget?.font = UIFont(name: "Gills Sans", size: 12)
            monthBudget?.font = UIFont(name: "Gills Sans", size: 12)
            thisMonthExpense?.text = "No Expense Yet"                                               //exception if no database found
            remainingBudget?.text = "No Remaining Budget"
            monthBudget?.text = "Please add a Budget"
        }
    }
    
    
    //calculate expense for last month
    func lastMonthExp() {
        sumItem = globalItem
        let lastMonthRange = Date().startOfLastMonth...Date().endOfLastMonth                                                  //define last month range
        
        if sumItem.count > 0 {
            var lastMonthExpense:Double = 0.00
            for i in 0 ..< sumItem.count {
                if lastMonthRange.contains(sumItem[i].date){                                                    //sum of last month expense
                    lastMonthExpense += sumItem[i].price
                }
            }
            let lastMonthAmount = String(format: "$%.02f", lastMonthExpense as CVarArg)
            lastMonthExpenseLabel?.text = lastMonthAmount                                                       //set value to label
        }
        else {
            lastMonthExpenseLabel?.text = "No Data Yet"                                                         //if no data from last month found
        }
    }
    
    
    //user budget function
    func changeBudget() {
        let alert = UIAlertController(title: "Please enter your budget below", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))                                   //alert message
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your budget here..."                                                         //set a textfield for the alert
            textField.keyboardType = .decimalPad                                                                        //set keyboard type for textfield
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in            //add done action after user finished adding budget
            let strCheck = alert.textFields?.first?.text
            if (strCheck?.trim() == "" || strCheck?.trim() == "." || strCheck?.trim() == ".." ){
                self.popUpAlert(withTitle: "Error", message: "Please enter a value.")                           //check for user's incorrect input
            }else{
                let newBudget = strCheck?.toDouble()
                self.monthBudget?.text = String(format: "$%.02f", newBudget as! CVarArg)
            }                                                                                                   //set new user budget to label
        }))
        
        self.present(alert, animated: true)
    }
    
    
    
    //////////////////home scene//////////////////
    
    
    
    //mock up data to table
    private lazy var createData: Void = {
        if globalItem.count == 0 {                                                                  //mock up database when the app starts
            let date = Date()
            globalItem.insert(itemModel(name: "Clothes", type: "Shopping", price: 110.7, date: date), at: 0)
            globalItem.insert(itemModel(name: "Electricity", type: "Services", price: 150.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Shoes", type: "Shopping", price: 212.90, date: date), at: 0)
            globalItem.insert(itemModel(name: "Lobster", type: "Foods", price: 89.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "KFC", type: "Foods", price: 20.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Car service", type: "Services", price: 112.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "House Rent", type: "Services", price: 400.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Lend Money", type: "Others", price: 100.0, date: date), at: 0)
            globalItem.insert(itemModel(name: "Red Cross Donation", type: "Others", price: 50.0, date: date), at: 0)
            sortedItem = globalItem
        }
    }()
    
    
    
    func getCategory(type:String) -> Array<itemModel> {
        let item:[itemModel] = []
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
