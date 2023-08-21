//
//  DataController.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "RecipeDesign")
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to lead: \(error.localizedDescription)")
            }
        }
    }
}

