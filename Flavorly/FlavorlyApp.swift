//
//  FlavorlyApp.swift
//  Flavorly
//
//  Created by Timea Bartha on 21/8/23.
//

import SwiftUI
private let lastVersionKey = "lastVersionLaunched"
@main
struct FlavorlyApp: App {
    @StateObject private var dataController = DataController()
    @StateObject var themeManager = ThemeManager()
    @State private var isContentLoaded = false
    @State private var showWhatsNew = false
    
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
            .sheet(isPresented: $showWhatsNew) {
                WhatsNewView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
            .onAppear {
                checkVersion()
            }
            .preferredColorScheme(themeManager.currentTheme.preferredColorScheme)
        }
    }
    private func checkVersion() {
            let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
            let lastVersion = UserDefaults.standard.string(forKey: lastVersionKey) ?? ""
            
            if currentVersion != lastVersion {
                // New version detected — show popup
                showWhatsNew = true
                // Save the current version
                UserDefaults.standard.setValue(currentVersion, forKey: lastVersionKey)
            }
        }
}
