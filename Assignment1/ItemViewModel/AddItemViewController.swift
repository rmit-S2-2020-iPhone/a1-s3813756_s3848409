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
    
    private var homeViewController = ViewController()
    private var itemViewModel = ItemViewModel()
    private var pickedType:String?
    private let expenseType = ["Foods","Shopping","Services","Others"]
    private let expenseTypePicker = UIPickerView()
    
    @IBOutlet weak var expenseTypePickerField: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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
        let dotCheck:String? = itemPrice.text
        if (dotCheck?.containsOnlyDoubles(string: dotCheck!))! {
            let dotCount = dotCheck?.filter({ $0 == "." }).count
            if ( dotCount! > 1) {
                HUD.flash(.labeledError(title: "Error", subtitle: "Price is invalid"), delay: 1)
            }
            
            let newItemName:String = itemNote.text ?? ""
            let newItemPrice = (dotCheck! as NSString).doubleValue                   //declare new item component to set new value in
            let newItemDate = itemDate.date
            var newItemType:String = ""
            
            if (pickedType == "Foods") {
                newItemType = "Foods"
            }else if (pickedType == "Shopping") {
                newItemType = "Shopping"
            }else if (pickedType == "Services") {               //if condition for expense type picker
                newItemType = "Services"
            }else if (pickedType == "Others"){
                newItemType = "Others"
            }
            
            if (newItemName.trim() == "" ||  newItemName.trim() == "."){
                HUD.flash(.labeledError(title: "Error", subtitle: "Note can't be empty"), delay: 1)
            }else if (newItemPrice <= 0) {                                                  //check for exception if user input incorrect value in textfield
                HUD.flash(.labeledError(title: "Error", subtitle: "Price can't be empty"), delay: 1)
            }else if (newItemType == "") {
                HUD.flash(.labeledError(title: "Error", subtitle: "Type can't be empty"), delay: 1)
            }
            else {
                itemViewModel.addItem(newItemName, newItemType, newItemPrice, newItemDate)
                itemViewModel.loadItems()                                                   //else add the new item to database and sort all data again
                self.homeViewController.homeTableView?.reloadData()
                HUD.flash(.success, delay: 0.5)
                itemPrice.text = ""
                itemNote.text = ""
                itemDate.date = Date()
            }
        }else {
            HUD.flash(.labeledError(title: "Error", subtitle: "Price is invalid"), delay: 1)
        }
        
    }
    
    func addDoneButton() {
        let toolBar = UIToolbar()                           //create a toolbar
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneAction))
        toolBar.setItems([doneButton], animated: true)
        expenseTypePickerField?.inputAccessoryView = toolBar
        itemPrice?.inputAccessoryView = toolBar                                         //set which textfield require a toolbox
        itemNote?.inputAccessoryView = toolBar
    }
    
    //close picker view
    @objc func doneAction() {
        self.view.endEditing(true)
    }

}
