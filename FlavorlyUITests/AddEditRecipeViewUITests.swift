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

    func testAppStartsEmpty()  {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCTAssertEqual(app.cells.count, 0, "There should be 0 recipes when the app is first launched.")
        
    }
    func testAppAddingRecipeWorks() {
        
        let app = XCUIApplication()
        app.launch()
        app.navigationBars["Flavorly"]/*@START_MENU_TOKEN@*/.buttons["Add Recipe"]/*[[".otherElements[\"Add\"]",".buttons[\"Add\"]",".buttons[\"Add Recipe\"]",".otherElements[\"Add Recipe\"]"],[[[-1,2],[-1,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["recipeNameTextField"]/*[[".cells",".textFields[\"Recipe name\"]",".textFields[\"recipeNameTextField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let authorsnametextfieldTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["authorsNameTextField"]/*[[".cells",".textFields[\"Author's name\"]",".textFields[\"authorsNameTextField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
       
        authorsnametextfieldTextField.tap()
        
        let ingredientstextfieldTextView = collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["ingredientsTextField"]/*[[".cells.textViews[\"ingredientsTextField\"]",".textViews[\"ingredientsTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
       
        ingredientstextfieldTextView.tap()
        
        let recipetextfieldTextView = collectionViewsQuery/*@START_MENU_TOKEN@*/.textViews["recipeTextField"]/*[[".cells.textViews[\"recipeTextField\"]",".textViews[\"recipeTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
       
        recipetextfieldTextView.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add"]/*[[".cells.buttons[\"Add\"]",".buttons[\"Add\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
   
    }
    func testListRowDeleteActionWorks_AndEditRecipeDeleteButtonActionWorks() {
        let app = XCUIApplication()
        app.launch()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["Recipename, By:, Recipeauthor"].swipeLeft()
        collectionViewsQuery.buttons["Delete"].tap()
        collectionViewsQuery.buttons["Add, By:, New"].tap()// add is recipe title and New is recipe author
        app.navigationBars["Recipe"]/*@START_MENU_TOKEN@*/.buttons["Trash"]/*[[".otherElements[\"Trash\"].buttons[\"Trash\"]",".buttons[\"Trash\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Delete recipe"].scrollViews.otherElements.buttons["Delete"].tap()
  
    }
   
   

}
