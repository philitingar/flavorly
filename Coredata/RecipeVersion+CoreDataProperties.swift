//
//  RecipeVersion+CoreDataProperties.swift
//  Flavourly
//
//  Created by Timea Bartha on 14/5/25.
//

import CoreData

@objc(RecipeVersion)
public class RecipeVersion: NSManagedObject {}

extension RecipeVersion {
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var changeDescription: String?
    @NSManaged public var recipeData: Data?
    @NSManaged public var author: String?
    @NSManaged public var recipe: Recipe?
}
