//
//  Assignment1UITests.swift
//  Assignment1UITests
//
//  Created by Phearith on 31/7/20.
//  Copyright © 2020 RMIT-iOS-s3848409-s3813756. All rights reserved.
//

import XCTest

class Assignment1UITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTabBarsNavigator() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.tabBars.buttons["Add"].tap()
        
        let priceTextField = app.textFields["$ 0.00"]
        priceTextField.tap()
        priceTextField.typeText("$20")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let noteTextField = app.textFields["Note"]
        noteTextField.tap()
        noteTextField.typeText("Domino")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
        let chooseExpenseTextField = app.textFields["Choose expense type..."]
        chooseExpenseTextField.tap()
        app/*@START_MENU_TOKEN@*/.pickers.pickerWheels["Foods"]/*[[".pickers.pickerWheels[\"Foods\"]",".pickerWheels[\"Foods\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()
        
 
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
       app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
        app.tabBars.buttons["Home"].tap()
        app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["Foods"]/*[[".segmentedControls.buttons[\"Foods\"]",".buttons[\"Foods\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
   
        
       
        XCTAssertTrue(app.tables.cells.staticTexts["KFC"].exists)
      
    }
    
 

}
