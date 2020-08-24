//
//  AddViewController.swift
//  Assignment1
//
//  Created by Phearith on 24/8/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit

class AddViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let expenseType = ["Foods","Services","Utilities","Rent"]
    
    @IBOutlet weak var expenseTypePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        expenseTypePicker.delegate = self
        expenseTypePicker.dataSource = self
    }
    
    func numberOfComponents(in expenseTypePicker: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ expenseTypePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expenseType.count
    }
    
    func pickerView(_ expenseTypePicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return expenseType[row]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
