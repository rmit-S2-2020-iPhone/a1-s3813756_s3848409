//
//  Request_Request.swift
//  Demo
//
//  Created by Rodney Cocker on 7/2/18.
//  Copyright © 2018 RMIT. All rights reserved.
//

import Foundation
import UIKit

protocol Refresh{
    func updateUI()
}
class REST_Request
{

    var items: [ItemModel] = []
    private let session = URLSession.shared
    var delegate: Refresh?

    private let base_url:String = "https://fakestoreapi.com/products"
    private let paramIngredients: String = "i="
    private let paramTitle: String = "&q="
    private let paramPages:String = "&pg3"


    func getItem(with itemName:String, itemPrice: String)
    {
        items = []
        let url = base_url + paramIngredients + itemName + paramTitle + itemPrice + paramPages

        let escapedAddress = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        if let url = URL(string: escapedAddress!)
        {
            let request = URLRequest(url: url)

            getData(request, element: "results")
        }
    }

    private func getData(_ request: URLRequest, element: String)
    {
        let task = session.dataTask(with: request, completionHandler: {
            data, response, downloadError in

            if let error = downloadError
            {
                print(error)
            }
            else
            {
                var parsedResult: Any! = nil
                do
                {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                }
                catch{
                    print()
                }

                let result = parsedResult as! [String:Any]

                print(result)
                let allItems = result[element] as! [[String:Any]]
                print(allItems)
                if allItems.count > 0
                {
                    for i in allItems
                    {
                        let title = i["title"] as! String
                        let price = i["price"] as! Double
                        let imageName = i["image"] as! String?

                        if (imageName?.count)! > 0
                        {
 
                                let items = ItemModel(itemName: title, itemType: "Others", itemPrice: price, itemDate: Date())
                                self.items.append(items)
                            
                        }
                        print()
                    }
                }
                else{
                    self.items.append(ItemModel(itemName: "No results", itemType: "", itemPrice: 0, itemDate: Date()))
                }

                DispatchQueue.main.async(execute:{
                    self.delegate?.updateUI()
                })


            }

        })
        task.resume()

    }

    static let sharedInstance = REST_Request()
    private init(){

        let session = URLSession.shared



        let searchUrl:String = "https://fakestoreapi.com/products"
        if let url = URL(string: searchUrl) {
            let request = URLRequest(url: url)
            let task = session.dataTask (with: request, completionHandler: { data, response, downloadError in
                let parsedResult: Any!
                do{
                    parsedResult =  try JSONSerialization.jsonObject(with: data!)
                }
                catch{
                    print()
                }
                // Process the results.
            })
            task.resume()

        }}}
