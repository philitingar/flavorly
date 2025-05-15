//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    private let themeUserDefaultsKey = "selectedThemeId"

    init() {
        let savedThemeId = UserDefaults.standard.string(forKey: themeUserDefaultsKey)
        self.currentTheme = AppTheme.find(by: savedThemeId)
        print("ThemeManager Initialized. Current theme: \(self.currentTheme.name) (Appearance: \(self.currentTheme.preferredColorScheme == .dark ? "Dark" : "Light"))")
    }

    var availableThemes: [AppTheme] {
        return AppTheme.availableThemes
    }

    func selectTheme(themeId: String) {
        if let newTheme = availableThemes.first(where: { $0.id == themeId }) {
            currentTheme = newTheme
            UserDefaults.standard.set(themeId, forKey: themeUserDefaultsKey)
            print("Theme selected and saved: \(newTheme.name) (Appearance: \(newTheme.preferredColorScheme == .dark ? "Dark" : "Light"))")
        } else {
            print("Error: Theme with ID \(themeId) not found.")
        }
    }
}
