//
//  ProductViewController.swift
//  Assignment1
//
//  Created by sokleng on 10/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit
import PKHUD
import Foundation

class ProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, Refresh {
    private var productViewModel = APIViewModel()
    private var homeViewController = ViewController()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productViewModel.rest_request()
        productViewModel.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        productViewModel.rest_request()
        self.productViewModel.delegate = self
        tableView.reloadData()
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let title = cell.viewWithTag(1000) as! UILabel
        let price = cell.viewWithTag(1002) as! UILabel
        let type = cell.viewWithTag(1001) as! UILabel
        let product = productViewModel.products
        
        for i in 0 ... indexPath.row {
            title.text = product[i].title
            price.text = "$ " + product[i].price.description
            type.text = product[i].category
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableItem = productViewModel.products[indexPath.row]
        productViewModel.addItem(tableItem.title, "Shopping", tableItem.price, Date())
        self.homeViewController.homeTableView?.reloadData()
        HUD.flash(.success)
    }
}
