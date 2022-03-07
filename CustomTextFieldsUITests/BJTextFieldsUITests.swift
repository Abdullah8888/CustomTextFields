//
//  BJTextFieldsUITests.swift
//  CustomTextFieldsUITests
//
//  Created by Abdullah on 01/03/2022.
//

import XCTest
import os.log
@testable import CustomTextFields

class BJTextFieldsUITests: XCTestCase {

    
    func testEmptyEntry() throws {
        let app = XCUIApplication()
        app.launch()
        
        given("If User enters is empty") {
            let userEntry = ""
            let firstNameTextField = app.textFields["First name"]
            
            when("Field is tap, and user entry is set as input") {
                firstNameTextField.tap()
                firstNameTextField.typeText(userEntry)
            }
            
            then("") {
                XCTAssertTrue(firstNameTextField.exists)
            }
        }
        
    }
    
    func testWrongNameEntry() throws {
        let app = XCUIApplication()
        app.launch()
    
        given("If User enters single character") {
            let userEntry = "N"
            let firstNameTextField = app.textFields["First name"]
            
            when("Field is tap, and user entry is set as input") {
                firstNameTextField.tap()
                firstNameTextField.typeText(userEntry)
            }
            
            then("Error message should show up") {
                XCTAssertTrue(firstNameTextField.exists)
                XCTAssertTrue(app.staticTexts["Please enter a valid first name"].exists)
            }
        }
    }
    
    func testRightNameEntry() throws {
        let app = XCUIApplication()
        app.launch()
        
        given("If user enters John") {
            let userEntry = "John"
            let firstNameTextField = app.textFields["First name"]
            
            when("Field is tap, and user entry is set as input") {
                firstNameTextField.tap()
                firstNameTextField.typeText(userEntry)
            }
            
            then("") {
                XCTAssertTrue(app.staticTexts["First name"].exists)
            }
        }
    }
    
}

extension XCTestCase {

    func given<A>(_ description: String, block: () throws -> A) rethrows -> A {
        os_log("1º Given %{public}@", description)
        return try XCTContext.runActivity(named: "Given " + description, block: { _ in try block() })
    }

    func when<A>(_ description: String, block: () throws -> A) rethrows -> A {
        os_log("2º When %{public}@", description)
        return try XCTContext.runActivity(named: "When " + description, block: { _ in try block() })
    }

    func then<A>(_ description: String, block: () throws -> A) rethrows -> A {
        os_log("3º Then %{public}@", description)
        return try XCTContext.runActivity(named: "Then " + description, block: { _ in try block() })
    }
}


