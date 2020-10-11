//
//  ProductViewController.swift
//  Assignment1
//
//  Created by sokleng on 10/10/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
     @IBOutlet weak var tableView: UITableView!

    
    var products = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        rest_request()
        }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let title = cell.viewWithTag(1000) as! UILabel
        let price = cell.viewWithTag(1002) as! UILabel
        let type = cell.viewWithTag(1001) as! UILabel
        
        for i in 0 ... indexPath.row {
            title.text = products[i].title
            price.text = "$ " + products[i].price.description
            type.text = products[i].category
        }
 
   

        return cell
    }
    
let baseURL = "https://fakestoreapi.com/products"

    
func rest_request(){
        guard let url = URL(string: baseURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                guard let jsonArray = jsonResponse as? [[String:Any]] else { return }
                
                for dic in jsonArray{
                    self.products.append(Product(dic))
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            
            
            } catch let parsingError{
                print("Error", parsingError)
            }
            
        }
        task.resume()
    }
    


}


