//
//  Assignment1UITests.swift
//  Assignment1UITests
//
//  Created by sokleng on 31/7/20.
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
    
    func uiTest(){
        testUIProfile()
        testUIAddItems()
        testUIDeleteItem()
        testTabBarsNavigator()
        testUINotValidItemInput()
    }
    
    func testUIAddItems(){
        let app = XCUIApplication()
        app.tabBars.buttons["Add"].tap()
        app.textFields["$ 0.00"].tap()
        
        // Check price textfield existence and input data
        let priceTextfield = app.textFields["$ 0.00"]
        XCTAssertTrue(priceTextfield.exists)
        priceTextfield.typeText("20")
        
        // Check note textfield existence and input data
        app.textFields["Note"].tap()
        let noteTextfield = app.textFields["Note"]
        XCTAssertTrue(noteTextfield.exists)
        noteTextfield.typeText("Domino")
        
        app.textFields["Choose expense type..."].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Shopping")
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Foods")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
        //  navigate to home page and check new input
        app.tabBars.buttons["Home"].tap()
        sleep(5)
        XCTAssertTrue(app.tables.cells.staticTexts["Domino"].exists)
    }
    
    func testTabBarsNavigator() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        // Test if the segment control exists
        XCTAssertTrue(app.segmentedControls.buttons["All"].exists)
        
        
        
        // Test Statistic page
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Statistics"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        XCTAssertTrue(element.exists)
        
        // Test Add new item page
        tabBarsQuery.buttons["Add"].tap()
        XCTAssertTrue(app.textFields["$ 0.00"].exists)
        XCTAssertTrue(app.textFields["Note"].exists)
        XCTAssertTrue(app.textFields["Choose expense type..."].exists)
        
        // Test profile page
        tabBarsQuery.buttons["Profile"].tap()
        XCTAssertTrue(app.buttons["pencil"].exists)
        
        
        // Test About page
        tabBarsQuery.buttons["Settings"].tap()
        XCTAssertTrue(app.tables.children(matching: .other)["BASIC SETTINGS"].children(matching: .other)["BASIC SETTINGS"].exists)
        XCTAssertTrue(app.tables.children(matching: .other)["ADVANCED SETTINGS"].children(matching: .other)["ADVANCED SETTINGS"].exists)
        XCTAssertTrue(app.tables.children(matching: .other)["HELP AND CONTACT"].children(matching: .other)["HELP AND CONTACT"].exists)
    }
    
    func testUIDeleteItem(){
        let app = XCUIApplication()
        if app.tables.cells.staticTexts["Domino"].exists{
            let beforeDelete = app.tables.cells.count
            app.tables.cells.staticTexts["Domino"].swipeLeft()
            app.tables.buttons["Delete"].tap()
            app.alerts["Item Deleted"].buttons["OK"].tap()
            
            // In testUIAddItems() we alr checked for added data existence
            // so in here we just need to check the data in not here anymore
            XCTAssertFalse(app.tables.cells.staticTexts["Domino"].exists)
            
            // Then we check if one cell has been remove
            let afterDelete = app.tables.cells.count
            XCTAssertLessThan(afterDelete, beforeDelete)
        } else {
            testUIAddItems()
            testUIDeleteItem()
        }
        
        
    }
    
    func testUINotValidItemInput(){
        
        
        let app = XCUIApplication()
        
        
        app.tabBars.buttons["Add"].tap()
        app.textFields["$ 0.00"].tap()
        
        // Check price textfield existence and input data
        let priceTextfield = app.textFields["$ 0.00"]
        XCTAssertTrue(priceTextfield.exists)
        priceTextfield.typeText("")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        let beforeAdd = app.tables.cells.count
        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
        // Check note textfield existence and input data
        app.textFields["Note"].tap()
        let noteTextfield = app.textFields["Note"]
        XCTAssertTrue(noteTextfield.exists)
        noteTextfield.typeText("Foods")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
        app.textFields["Choose expense type..."].tap()
        app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "Shopping")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
        let afterAdd = app.tables.cells.count
        
        // Now we can check if afterAdd and beforeAdd are equal,
        // it means the invalid input has not been added to core data
        XCTAssertEqual(afterAdd, beforeAdd)
        
    }
    
    func testUIProfile(){
        //UI Testing on Profile Scene
        let monthlyBudgetInput = "200.00"
        let app = XCUIApplication()
        app.tabBars.buttons["Profile"].tap()
        app.buttons["pencil"].tap()
        app.sheets.buttons["Change Budget"].tap()
        
        let budgetTextField = app.alerts["Please enter your budget below"]
        // Check if the textfield is exist on the screen
        XCTAssertTrue(budgetTextField.exists)
        budgetTextField.collectionViews.textFields["Input your budget here..."].typeText(monthlyBudgetInput)
        budgetTextField.buttons["OK"].tap()
        
        // Test the input and display data to be the same
        let monthlyBudget = app.staticTexts.element(matching: .any, identifier: "monthlyBudget").label
        XCTAssertEqual(monthlyBudget, "$" + monthlyBudgetInput)
        
    }
    
    
}
