//
//  Recipe+CoreDataProperties.swift
//  Flavorly
//
//  Created by Timea Bartha on 22/1/24.
//
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe")
    }

    @NSManaged public var author: String?
    @NSManaged public var id: UUID?
    @NSManaged public var ingredients: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var recipeToTag: NSSet?
    
    public var tagArray: [Tag] {
        let set = recipeToTag as? Set<Tag> ?? []
        return set.sorted {
            $0.title ?? "" < $1.title ?? ""
        }
    }

}

// MARK: Generated accessors for recipeToTag
extension Recipe {

    @objc(addRecipeToTagObject:)
    @NSManaged public func addToRecipeToTag(_ value: Tag)

    @objc(removeRecipeToTagObject:)
    @NSManaged public func removeFromRecipeToTag(_ value: Tag)

    @objc(addRecipeToTag:)
    @NSManaged public func addToRecipeToTag(_ values: NSSet)

    @objc(removeRecipeToTag:)
    @NSManaged public func removeFromRecipeToTag(_ values: NSSet)

}

extension Recipe : Identifiable {

}
extension Recipe {
    @NSManaged public var isShared: Bool
    @NSManaged public var owner: String?
    @NSManaged public var sharedWith: Set<String>?
    @NSManaged public var versions: Set<RecipeVersion>?
    @NSManaged public var comments: Set<RecipeComment>?
    
    @objc(addVersionsObject:)
    @NSManaged public func addToVersions(_ value: RecipeVersion)

    @objc(removeVersionsObject:)
    @NSManaged public func removeFromVersions(_ value: RecipeVersion)

    @objc(addVersions:)
    @NSManaged public func addToVersions(_ values: NSSet)

    @objc(removeVersions:)
    @NSManaged public func removeFromVersions(_ values: NSSet)
    
    // Repeat for comments relationship...
    
    public var sharedWithUsers: [String] {
        Array(sharedWith ?? [])
    }
}
extension Recipe {
    func createVersionSnapshot(description: String, author: String) {
        guard let context = self.managedObjectContext else { return }
        
        let version = RecipeVersion(context: context)
        version.id = UUID()
        version.timestamp = Date()
        version.changeDescription = description
        version.author = author
        
        // Create and encode snapshot
        let snapshot = RecipeSnapshot(from: self)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        version.recipeData = try? encoder.encode(snapshot)
        
        // Add to relationship
        self.addToVersions(version)
    }
    
    func restore(from version: RecipeVersion) {
        guard
            let data = version.recipeData,
            let snapshot = try? JSONDecoder().decode(RecipeSnapshot.self, from: data)
        else { return }
        
        self.title = snapshot.title
        self.author = snapshot.author
        self.ingredients = snapshot.ingredients
        self.text = snapshot.text
        self.timestamp = snapshot.timestamp
        
        // Handle tags restoration if needed
        // Note: This requires additional implementation
    }
}
