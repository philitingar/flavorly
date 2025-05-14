//
//  RecipeComment+CoreDataProperties.swift.swift
//  Flavourly
//
//  Created by Timea Bartha on 14/5/25.
//

import CoreData

@objc(RecipeComment)
public class RecipeComment: NSManagedObject {}

extension RecipeComment {
    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var author: String?
    @NSManaged public var recipe: Recipe?
}
