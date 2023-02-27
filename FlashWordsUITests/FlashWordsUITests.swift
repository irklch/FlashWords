//
//  FlashWordsUITests.swift
//  FlashWordsUITests
//
//  Created by Ирина Кольчугина on 04.02.2023.
//

import XCTest

final class FlashWordsUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testAddNewFolderSuccess() {
        if !app.buttons["add"].exists {
            app.navigationBars["FlashWords.WordListTableVC"].buttons["Folders"].tap()
        }
        let foldersOldCount = app.tables.children(matching: .cell).count
        setAddNewFolder()
        let foldersNewCount = app.tables.children(matching: .cell).count

        XCTAssert(foldersOldCount < foldersNewCount)
    }

    private func setAddNewFolder() {
        app.buttons["add"].tap()
        app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app/*@START_MENU_TOKEN@*/.keys["f"]/*[[".keyboards.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["d"]/*[[".keyboards.keys[\"d\"]",".keys[\"d\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        app.buttons["selected"].tap()
    }

    func testAddNewWordSuccess() {
        if app.buttons["add"].exists {
            if app.tables.cells.count == 1 {
                setAddNewFolder()
            }
            app.tables.children(matching: .cell).element(boundBy: 1).tap()
        } else if app.staticTexts["All words"].exists {
            app.navigationBars["FlashWords.WordListTableVC"].buttons["Folders"].tap()
            app.tables.children(matching: .cell).element(boundBy: 1).tap()
        }
        app.textViews["New word"].tap()
        app.keys["S"].tap()

        app.textViews["Translation"].tap()
        app.keys["L"].tap()

        let rowsOldCount = app.tables.children(matching: .cell).count
        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let rowsNewCount = app.tables.children(matching: .cell).count
        XCTAssert(rowsOldCount < rowsNewCount)
    }

    func testAddNewWordFailure() {
        app.tables.children(matching: .cell).element(boundBy: 1).children(matching: .textField).element.tap()
        let textfield = app.textViews["New word"]
        textfield.tap()
        app.keys["S"].tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add"]/*[[".buttons[\"Add\"].staticTexts[\"Add\"]",".staticTexts[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssert(app.buttons["You need to write words"].exists)
    }

    func testDeleteWordSuccess() {
        let rowsOldCount = app.tables.children(matching: .cell).count
        app.tables.children(matching: .cell).element(boundBy: 0).swipeLeft()
        app.tables.buttons["Delete"].tap()
        let rowsNewCount = app.tables.children(matching: .cell).count
        XCTAssert(rowsOldCount > rowsNewCount)

    }

    func testDeleteFolderSuccess() {
        if !app.buttons["add"].exists {
            app.navigationBars["FlashWords.WordListTableVC"].buttons["Folders"].tap()
        }
        let cellsOldCount = app.tables.children(matching: .cell).count
        app.tables.children(matching: .cell).element(boundBy: 1).swipeLeft()
        app.tables.buttons["trash"].tap()
        let cellsNewCount = app.tables.children(matching: .cell).count
        XCTAssert(cellsOldCount > cellsNewCount)
    }

}
