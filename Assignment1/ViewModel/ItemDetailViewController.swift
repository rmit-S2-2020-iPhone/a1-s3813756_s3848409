//
//  ItemDetailViewController.swift
//  Assignment1
//
//  Created by Phearith on 30/9/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var detailName:String?
    var detailPrice:String?
    var detailType:String?
    var detailDate:String?
    
    var util = Utilities()
    @IBOutlet weak var itemDetailImage: UIImageView!
    @IBOutlet weak var itemDetailPrice: UITextField!
    @IBOutlet weak var itemDetailName: UITextField!
    @IBOutlet weak var itemDetailType: UITextField!
    @IBOutlet weak var itemDetailDate: UITextField!
    @IBAction func changeDetail(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemDetailPrice.text = detailPrice
        itemDetailName.text = detailName
        itemDetailType.text = detailType
        itemDetailDate.text = detailDate
        if itemDetailType.text == "Foods" {
            itemDetailImage.image = UIImage(named: "food")
        }else if itemDetailType.text == "Shopping" {
            itemDetailImage.image = UIImage(named: "shopping")
        }else if itemDetailType.text == "Services" {
            itemDetailImage.image = UIImage(named: "services")
        }else if itemDetailType.text == "Others" {
            itemDetailImage.image = UIImage(named: "others")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
    }
    
    

}
