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
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func unitTest(){
        testItemNotEmpty()
        testItemNotNil()
        testItemInputCorrectly()
        testDeleteItem()
        testEditItem()
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
        // First we check the array is empty
        XCTAssertTrue(items.isEmpty)
        
        // Then we add items to array
        object = appDelegate?.persistentContainer.viewContext
        ivm.addItem("KFC", "Foods", 30, Date())
        itemRequest.sortDescriptors = [sortDescriptor]
        do {
            try items = object.fetch(itemRequest)
            
            // Now we need to check if it is not empty anymore
            // after using addItem()
            XCTAssertFalse(items.isEmpty)
        }catch {
            print("Could not load data")
        }
        
        
    }
    
    func testItemNotNil() {
        // Check for nil incase add items does not work
        // and return a nil value
        if items.isEmpty == true {
            testItemNotEmpty()
            testItemNotNil()
        } else {
            XCTAssertNotNil(items)
        }

        
    }
    
    func testItemInputCorrectly(){
        if items.isEmpty == true {
            testItemNotEmpty()
            testItemInputCorrectly()
        } else {
            sumItem = items
            XCTAssertNotNil(sumItem)
            for i in 0 ..< sumItem.count {
                if sumItem[i].name == "KFC"{
                    //  Below statement was made to make sure the test will fail
                    //  So we can make sure the next one is designed to pass
                    //  XCTAssertTrue(sumItem[i].name!.isEmpty)
                    XCTAssertEqual(sumItem[i].name, "KFC")
                } else {
                    print("Reload")
                }
            }
        }
    }
    
    func testDeleteItem() {
        if items.isEmpty == true {
            testItemNotEmpty()
            testDeleteItem()
        } else {
            sumItem = items
            XCTAssertNotNil(sumItem)
            for i in 0 ..< sumItem.count {
                if sumItem[i].name == "KFC"{
                    ivm.deleteItems(sumItem[i])
                    XCTAssertNotEqual(sumItem[i].name, "KFC")
                } else {
                    print("Reload")
                }
            }
            
        }
    }
    
    func testEditItem(){
        // We need to check if the item is empty first
        // if we do not check empty array and it appears to be
        // this test will fail.
        if items.isEmpty == true {
            testItemNotEmpty()
            testEditItem()
        } else {
            for i in 0 ..< items.count{
            ivm.updateItem(items[i], "Shoes", 15, "Shopping", Date())
    
            // Now we can compare the value after updateItem()
            XCTAssertEqual(items[i].name, "Shoes")
            XCTAssertEqual(items[i].price, 15)
            XCTAssertEqual(items[i].type, "Shopping")
            
            }
        }
    }
}
