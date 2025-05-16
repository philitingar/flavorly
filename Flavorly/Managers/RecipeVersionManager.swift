//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 14/5/25.
//
import SwiftUI
class RecipeVersionManager {
    static let shared = RecipeVersionManager()
    
    private init() {}
    
    func createVersion(for recipe: Recipe, description: String, author: String) {
        recipe.createVersionSnapshot(description: description, author: author)
        try? recipe.managedObjectContext?.save()
    }
    
    func getVersions(for recipe: Recipe) -> [RecipeVersion] {
        guard let versions = recipe.versions else { return [] }
        return versions.sorted { $0.timestamp! > $1.timestamp! }
    }
}
