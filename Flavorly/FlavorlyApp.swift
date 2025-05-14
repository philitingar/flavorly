//
//  FlavorlyApp.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//

import SwiftUI

@main
struct FlavorlyApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
