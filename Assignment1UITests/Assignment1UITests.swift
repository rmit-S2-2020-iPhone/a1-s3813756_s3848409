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
        tabBarsQuery.buttons["About"].tap()
        XCTAssertTrue(app.tables.children(matching: .other)["DEVELOPER"].children(matching: .other)["DEVELOPER"].exists)
        XCTAssertTrue(app.tables.children(matching: .other)["CONTACT"].children(matching: .other)["CONTACT"].exists)
        XCTAssertTrue(app.tables.children(matching: .other)["ABOUT US"].children(matching: .other)["ABOUT US"].exists)
        
      
    }
    
    func testUIInvalidAddItems(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Add"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.buttons["Add"].tap()
        
        
        
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
