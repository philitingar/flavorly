//
//  AddEditRecipeViewUITests.swift
//  FlavorlyUITests
//
//  Created by Timea Bartha on 21/12/23.
//

import XCTest

final class AddEditRecipeViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
/*
    func testAppStartsEmpty()  {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.cells.count, 0, "There should be 0 recipes when the app is first launched.")
        
    }
 */
    func testAppAddingRecipeWorks() {
        
        let collectionViewsQuery = XCUIApplication().collectionViews
        let authorsnametextfieldTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["authorsNameTextField"]/*[[".cells",".textFields[\"Author's name\"]",".textFields[\"authorsNameTextField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        authorsnametextfieldTextField.tap()
        authorsnametextfieldTextField.tap()
        
        let ingredientstextfieldTextView = collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["ingredientsTextField"]/*[[".cells.textViews[\"ingredientsTextField\"]",".textViews[\"ingredientsTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        ingredientstextfieldTextView.tap()
        ingredientstextfieldTextView.tap()
        
        let recipetextfieldTextView = collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["recipeTextField"]/*[[".cells.textViews[\"recipeTextField\"]",".textViews[\"recipeTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        recipetextfieldTextView.tap()
        recipetextfieldTextView.tap()
        
        let addThemOneByOneTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Add them one by one"]/*[[".cells.textFields[\"Add them one by one\"]",".textFields[\"Add them one by one\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        addThemOneByOneTextField.tap()
        addThemOneByOneTextField.tap()
        
        let addButton = collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".cells.buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        addButton.tap()
        addThemOneByOneTextField.tap()
        addButton.tap()
        addThemOneByOneTextField.tap()
        addButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add Recipe"]/*[[".cells.buttons[\"Add Recipe\"]",".buttons[\"Add Recipe\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
       
        
   
    }
    func testListRowDeleteActionWorks_AndEditRecipeDeleteButtonActionWorks() {
       
    }
   
   

}
