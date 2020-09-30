//
//  ItemDetailViewController.swift
//  Assignment1
//
//  Created by Phearith on 30/9/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var itemDetailImage: UIImageView!
    @IBOutlet weak var itemDetailPrice: UITextField!
    @IBOutlet weak var itemDetailName: UITextField!
    @IBOutlet weak var itemDetailType: UITextField!
    @IBOutlet weak var itemDetailDate: UITextField!
    @IBAction func changeDetail(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
