//
//  KekhaneUITests.swift
//  KekhaneUITests
//
//  Created by Jack Warris on 17/06/2017.
//  Copyright © 2017 com.jackwarris. All rights reserved.
//

import XCTest

class KekhaneUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // run this to test the UI for placing an order
    
    func testPlaceOrder() {
        let app = XCUIApplication()
        app.buttons["New Order"].tap()
        let collectionViewsQuery = app.collectionViews
        let elementsQuery = collectionViewsQuery.children(matching: .cell).element(boundBy: 0).otherElements
        elementsQuery.children(matching: .textField).element(boundBy: 1).tap()
        elementsQuery.children(matching: .textField).element(boundBy: 0).tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).otherElements.children(matching: .textField).element(boundBy: 0).tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).otherElements.children(matching: .textField).element(boundBy: 0).tap()
        app.alerts["Maximum Toppings Selected"].buttons["OK"].tap()
        app.buttons["Create Drink"].tap()
        let textField = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element
        textField.tap()
        app.keys["o"].tap()
        app.keys["r"].tap()
        app.keys["d"].tap()
        app.keys["e"].tap()
        app.keys["r"].tap()
        app.buttons["Done"].tap()
        app.buttons["Confirm Order"].tap()
    }
}
