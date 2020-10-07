//
//  MasterDetailViewController.swift
//  Assignment1
//
//  Created by Phearith on 7/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit

class MasterDetailViewController: UIViewController {
    
    var editItem:Item?
    var utility = Utility()
    
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

        getItemDetail()
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
        itemDetailPrice?.text = "- $" + String(editItem!.price)
        itemDetailName?.text = editItem?.name
        itemDetailDate?.text = utility.dateFormatter(itemDate:editItem!.date!)
        itemDetailType?.text = editItem?.type
    }
    
    func updateItemDetail() {
        let newDetailName = itemDetailName?.text
        let newDetailPrice = itemDetailPrice?.text
        let newDetailDate = itemDetailDate?.text
        let newDetailType = itemDetailDate?.text
        
    }

}
