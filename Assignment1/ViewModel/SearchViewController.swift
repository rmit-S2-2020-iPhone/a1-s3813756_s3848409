//
//  SearchViewController.swift
//  Assignment1
//
//  Created by sokleng on 6/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, Refresh{
    

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = ItemViewModel()
    
    @IBAction func search(_sender: Any){
        viewModel.getItem()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self 
        viewModel.delegate = self
        

    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = cell.viewWithTag(1000) as! UILabel
        let price = cell.viewWithTag(1001) as! UILabel
//        let des = cell.viewWithTag(1001) as! UILabel
//        let imageView = cell.viewWithTag(1002) as! UIImageView
        
        name.text =  viewModel.getNameFor(index: indexPath.row)
        price.text = viewModel.getPriceFor(index: indexPath.row)
//        imageView.image = viewModel.getRecipeImageFor(index: indexPath.row)
        
        return cell
    }
    
    func updateUI(){
        tableView.reloadData()
    }
}
