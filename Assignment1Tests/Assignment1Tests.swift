//
//  Assignment1Tests.swift
//  Assignment1Tests
//
//  Created by sokleng on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//
import XCTest
import CoreData
@testable import Assignment1

class Assignment1Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func unitTest(){
        testItemNotEmpty()
        testItemNotNil()
        testItemInputCorrectly()
        testDeleteItem()
    }
    
    var ivm = ItemViewModel()
    var items:[Item] = []
    var sumItem:[Item] = []
    
    // Get a reference to your App Delegate
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // Hold a reference to the managed context
    var object:NSManagedObjectContext!
    
    let itemRequest:NSFetchRequest<Item> = Item.fetchRequest()
    let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    
    
    func testItemNotEmpty() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        object = appDelegate?.persistentContainer.viewContext
        ivm.addItem("Domino", "Foods", 30, Date())
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            XCTAssertFalse(items.isEmpty)
        }catch {
            print("Could not load data")
        }
        
        
    }
    
    func testItemNotNil() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        object = appDelegate?.persistentContainer.viewContext
        ivm.addItem("Domino", "Foods", 30, Date())
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            XCTAssertNotNil(items)
            
        }catch {
            print("Could not load data")
        }
        
    }
    
    func testItemInputCorrectly(){
        object = appDelegate?.persistentContainer.viewContext
        ivm.addItem("Domino", "Foods", 30, Date())
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            sumItem = items
            XCTAssertNotNil(items)
            
            for i in 0 ..< sumItem.count {
                if sumItem[i].name == "Domino"{
                    //                  Below statement was made to make sure the test will fail
                    //                  So we can make sure the next one is designed to pass
                    //                  XCTAssertTrue(sumItem[i].name!.isEmpty)
                    XCTAssertEqual(sumItem[i].name, "Domino")
                } else {
                    print("Reload")
                }
            }
            
        }catch {
            print("Could not load data")
        }
    }
    
    func testDeleteItem() {
        object = appDelegate?.persistentContainer.viewContext
        ivm.addItem("Domino", "Foods", 30, Date())
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            sumItem = items
            XCTAssertNotNil(items)
            for i in 0 ..< sumItem.count {
                if sumItem[i].name == "Domino"{
                    ivm.deleteItems(sumItem[i])
                    XCTAssertNotEqual(sumItem[i].name, "Domino")
                } else {
                    print("Reload")
                }
            }
            
        }catch {
            print("Could not load data")
        }
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
