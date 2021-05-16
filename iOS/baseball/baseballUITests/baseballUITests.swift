//
//  baseballUITests.swift
//  baseballUITests
//
//  Created by 양준혁 on 2021/05/03.
//

import XCTest

class baseballUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testEnterTheGame() {
        let app = XCUIApplication()
        app/*@START_MENU_TOKEN@*/.staticTexts["Button"]/*[[".buttons[\"Button\"].staticTexts[\"Button\"]",".staticTexts[\"Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //MARK: find continue Button identifier
                
    }
}
