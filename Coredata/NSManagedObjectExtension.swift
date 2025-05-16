//
//  NSManagedObjectExtension.swift
//  Flavorly
//
//  Created by Timea Bartha on 30/1/24.
//

// needed to prevent error: Multiple NSEntityDescriptions claim the NSManagedObject subclass
// info: https://github.com/drewmccormack/ensembles/issues/275#issuecomment-408710451

import CoreData

public extension NSManagedObject {
  convenience init(using usedContext: NSManagedObjectContext) {
    let name = String(describing: type(of: self))
    let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
    self.init(entity: entity, insertInto: usedContext)
  }
}
