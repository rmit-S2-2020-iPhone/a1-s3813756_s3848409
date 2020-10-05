//
//  Assignment1Tests.swift
//  Assignment1Tests
//
//  Created by Phearith on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import XCTest
@testable import Assignment1

class Assignment1Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPerformanceExample() {
        self.measure {
        }
    }
    


    var globalItem: ItemModel = ItemModel(itemName: "Domino", itemType: "Foods", itemPrice: 20, itemDate: Date())
    
    func unitTest(){
        testGlobalItemsNotNil()
    }
    
    func testGlobalItemsNotNil() {
        // Test ItemModel value in case they are nill
        // All existed items can not be nil
        XCTAssertNotNil(globalItem.itemName)
        XCTAssertNotNil(globalItem.itemType)
        XCTAssertNotNil(globalItem.itemPrice)
        XCTAssertNotNil(globalItem.itemDate)
    }
    
    func testGlobalItemsNotEmpty(){
        // Beside nil, global items can not be empty too
        XCTAssertFalse(globalItem.itemName.isEmpty)
        XCTAssertFalse(globalItem.itemPrice.isZero)
        XCTAssertFalse(globalItem.itemType.isEmpty)
    }
    

}
