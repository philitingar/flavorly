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
    @StateObject var themeManager = ThemeManager()
    @State private var isContentLoaded = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                TabBarView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .accentColor(themeManager.currentTheme.accentColor)
                    .environmentObject(themeManager)
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        isContentLoaded = true
                    }
                }
            }
            .preferredColorScheme(themeManager.currentTheme.preferredColorScheme)
        }
    }
}
