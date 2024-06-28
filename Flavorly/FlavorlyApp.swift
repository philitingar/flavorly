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
    @StateObject private var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(themeManager)
        }
    }
}
