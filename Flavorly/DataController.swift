//
//  DataController.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "RecipeDesign")
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
        
    }()
    
}

