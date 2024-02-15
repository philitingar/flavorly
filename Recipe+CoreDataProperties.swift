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
    @NSManaged public var hardness: Int16
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
