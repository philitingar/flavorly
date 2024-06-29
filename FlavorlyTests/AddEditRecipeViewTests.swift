//
//  AddEditRecipeViewTests.swift
//  FlavorlyTests
//
//  Created by Timea Bartha on 20/10/23.
//

import XCTest
import CoreData
@testable import Flavourly


final class AddEditRecipeViewTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        try super.setUpWithError()
        managedObjectContext = createTestManagedObjectContext()
    }

    override func tearDownWithError() throws {
        managedObjectContext = nil
        try super.tearDownWithError()
    }

    func createTestManagedObjectContext() -> NSManagedObjectContext {
            let container = NSPersistentContainer(name: "RecipeDesign")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            
            container.loadPersistentStores { (_, error) in
                if let error = error {
                    fatalError("Failed to create in-memory store: \(error)")
                }
            }
            
            return container.viewContext
        }
    
    func testSaveRecipeToManagedObjectContext() {
        do {
            let newRecipe = Recipe(using: managedObjectContext)
            newRecipe.id = UUID()
            newRecipe.title = "title"
            newRecipe.author = "author"
            newRecipe.ingredients = "ingredients"
            newRecipe.text = "text"
            try managedObjectContext.save()
        } catch {
           
            XCTFail("Failed to save managed object context: \(error)")
        }
    }
    
    func testAddNewRecipeFunction() {
        let title = "new title"
        let author = "new author"
        let ingredients = "new ingredients"
        let text = "new text"
        let newTags: [Tag] = []
        
        addNewRecipe(title: title, author: author, ingredients: ingredients, text: text, newTags: newTags, moc: managedObjectContext)
        let fetchReq: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let results = try? managedObjectContext.fetch(fetchReq)
        let resultsArr = results ?? [Recipe]()
        let firstResult = resultsArr[0]
        XCTAssertEqual(firstResult.title, title, "The new title should have been saved, but it didn't")
        XCTAssertEqual(firstResult.author, author, "The new author should have been saved, but it didn't")
        XCTAssertEqual(firstResult.ingredients, ingredients, "The new ingredients should have been saved, but they didn't")
        XCTAssertEqual(firstResult.text, text, "The new text should have been saved, but it didn't")
 
    }
    
    func testEditSavedRecipeFunction () {
        // create initial record for the recipe
        let recipe = Recipe(using: managedObjectContext)
        recipe.id = UUID()
        recipe.title = "some title"
        recipe.author = "some author"
        
        try? managedObjectContext.save()
        
        // define the new values for updating
        let title = "edited title"
        let author = "edited author"
        let ingredients = "edited ingredients"
        let text = "edited text"
        let newTags: [Tag] = []
        
        editSavedRecipe(recipe: recipe, title: title, author: author, ingredients: ingredients, text: text,newTags: newTags, moc: managedObjectContext)
        
        // reload the recipe record to check if it was updated correctly
        let fetchReq: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        let results = try? managedObjectContext.fetch(fetchReq)
        let resultsArr = results ?? [Recipe]()
        let firstResult = resultsArr[0]
        XCTAssertEqual(firstResult.title, title, "The edited title should have been saved, but it didn't")
        XCTAssertEqual(firstResult.author, author, "The edited author should have been saved, but it didn't")
        XCTAssertEqual(firstResult.ingredients, ingredients, "The edited ingredients should have been saved, but they didn't")
        XCTAssertEqual(firstResult.text, text, "The edited text should have been saved, but it didn't")
    }
    
    

}
