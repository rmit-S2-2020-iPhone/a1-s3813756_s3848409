//
//  AddItemViewController.swift
//  Assignment1
//
//  Created by Phearith on 3/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import PKHUD

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var homeViewController = ViewController()
    
    let expenseType = ["Foods","Shopping","Services","Others"]
    @IBOutlet weak var expenseTypePickerField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    let expenseTypePicker = UIPickerView()
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        addNewItem()                                                //addnewitem function will be called after user click "add" button
    }
    @IBOutlet weak var itemNote: UITextField!
    @IBOutlet weak var itemDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButton()
        
        itemPrice?.keyboardType = .decimalPad
        
        expenseTypePickerField?.inputView = expenseTypePicker       //initialise expense type picker field
        expenseTypePicker.delegate = self                           //set source for expense type picker
        expenseTypePicker.dataSource = self
    }
    

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
            homeViewController.popUpAlert(withTitle: "Error", message: "Please add a note for this item")
        }else if (newItemPrice <= 0) {                                                          //check for exception if user input incorrect value in textfield
            homeViewController.popUpAlert(withTitle: "Error", message: "Please add a value for this item")
        }else if (newItemType?.trim() == nil) {
            homeViewController.popUpAlert(withTitle: "Error", message: "Please choose a type for this item")
        }
        else {
            globalItem.insert(ItemModel(name: newItemName!, type: newItemType!, price: newItemPrice, date: newItemDate), at:0)
            homeViewController.sortData()                                                                          //else add the new item to database and sort all data again
            HUD.flash(.success, delay: 0.5)
            itemPrice.text = ""
            itemNote.text = ""
            itemDate.date = Date()
        }
    }
    
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

}
