//
//  MasterDetailViewController.swift
//  Assignment1
//
//  Created by Phearith on 7/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import PKHUD

class MasterDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var editItem:Item?
    private var utility = Utility()
    private var itemViewModel = ItemViewModel()
    private let datePicker = UIDatePicker()
    private let itemTypePicker = UIPickerView()
    private let expenseType = ["Foods","Shopping","Services","Others"]
    private var pickedType:String?
    
    @IBOutlet weak var itemDetailImage: UIImageView!
    @IBOutlet weak var itemDetailPrice: UITextField!
    @IBOutlet weak var itemDetailName: UITextField!
    @IBOutlet weak var itemDetailType: UITextField!
    @IBOutlet weak var itemDetailDate: UITextField!
    @IBAction func changeItemDetail(_ sender: Any) {
        updateItemDetail()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        getItemDetail()
        
        itemDetailType?.inputView = itemTypePicker       //initialise expense type picker field
        itemTypePicker.delegate = self                           //set source for expense type picker
        itemTypePicker.dataSource = self
    }
    
    
    func getItemDetail() {
        if let editItem = editItem {
            if editItem.type == "Foods" {
                itemDetailImage?.image = UIImage(named:ItemCategory.food.rawValue)
            }else if editItem.type == "Shopping" {
                itemDetailImage?.image = UIImage(named:ItemCategory.shopping.rawValue)
            }else if editItem.type == "Services" {
                itemDetailImage?.image = UIImage(named:ItemCategory.service.rawValue)
            }else if editItem.type == "Others" {
                itemDetailImage?.image = UIImage(named:ItemCategory.others.rawValue)
            }
        }
        setCurrencyLabelToTextField()
        itemDetailPrice?.text = String(editItem!.price)
        itemDetailName?.text = editItem?.name
        itemDetailDate?.text = utility.dateFormatter(itemDate:editItem!.date!)
        itemDetailType?.text = editItem?.type
    }
    
    func setCurrencyLabelToTextField() {
        let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        leftLabel.text = "  $"
        leftLabel.textColor = .lightGray
        itemDetailPrice?.leftView = leftLabel
        itemDetailPrice?.leftViewMode = .always
    }
    
    func createDatePicker() {
        itemDetailPrice.keyboardType = .decimalPad
        itemDetailDate.inputView = datePicker               //assign datepicker to our textfield
        let toolbar = UIToolbar()                           //create a toolbar
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([doneButton], animated: true)      //add a done button on this toolbar
        itemDetailDate.inputAccessoryView = toolbar
        itemDetailType.inputAccessoryView = toolbar
        itemDetailName.inputAccessoryView = toolbar
        itemDetailPrice.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        let itemDate = datePicker.date 
        itemDetailDate.text = utility.dateFormatter(itemDate: itemDate)
        self.view.endEditing(true)
    }
    
    //picker view function
    func numberOfComponents(in itemTypePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ itemTypePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseType.count
    }
    
    func pickerView(_ itemTypePicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseType[row]
    }
    
    func pickerView(_ itemTypePicker: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        itemDetailType.text = expenseType[row]
        pickedType = String(expenseType[row])
    }
    
    func updateItemDetail() {
        let dotCheck:String? = itemDetailPrice?.text
        if (dotCheck?.containsOnlyDoubles(string: dotCheck!))! {
            let dotCount = dotCheck?.filter({ $0 == "." }).count
            if ( dotCount! > 1) {
                HUD.flash(.labeledError(title: "Error", subtitle: "Price is invalid"), delay: 1)
            }else if (itemDetailPrice.text == nil || itemDetailPrice.text == "" || itemDetailPrice.text == ".") {
                HUD.flash(.labeledError(title: "Error", subtitle: "Price can't be empty"), delay: 1)
            }else if (itemDetailName.text == nil || itemDetailName.text?.trim() == "" || itemDetailName.text == ".") {
                HUD.flash(.labeledError(title: "Error", subtitle: "Note can't be empty"), delay: 1)
            }else {
                let newName = itemDetailName.text!
                let newPrice = dotCheck!.toDouble()!
                let newType = itemDetailType.text!
                let newDate = datePicker.date
                itemViewModel.updateItem(editItem!, newName, newPrice, newType, newDate)
                HUD.flash(.success)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        else {
            HUD.flash(.labeledError(title: "Error", subtitle: "Price is invalid"), delay: 1)
        }
        
    }

}
