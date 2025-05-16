//
//  Tag+CoreDataProperties.swift
//  Flavorly
//
//  Created by Timea Bartha on 22/1/24.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var tagToRecipe: NSSet?

}

// MARK: Generated accessors for tagToRecipe
extension Tag {

    @objc(addTagToRecipeObject:)
    @NSManaged public func addToTagToRecipe(_ value: Recipe)

    @objc(removeTagToRecipeObject:)
    @NSManaged public func removeFromTagToRecipe(_ value: Recipe)

    @objc(addTagToRecipe:)
    @NSManaged public func addToTagToRecipe(_ values: NSSet)

    @objc(removeTagToRecipe:)
    @NSManaged public func removeFromTagToRecipe(_ values: NSSet)

}

extension Tag : Identifiable {

}
