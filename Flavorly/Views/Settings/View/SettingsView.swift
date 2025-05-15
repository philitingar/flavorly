//
//  SettingsView.swift
//  Flavourly
//
//  Created by Timea Bartha on 14/5/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var navigationPath: NavigationPath
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
                VStack{
                    List {
                        Section(header:
                                    Text("PERSONALIZATION")
                            .font(.caption2)
                            .bold()
                            .foregroundColor(themeManager.currentTheme.primaryTextColor)
                        ) {
                            NavigationLink(value: NavigationDestination.themes) {
                                HStack {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .commonIconStyle()
                                    Text("Themes")
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                                }
                            }.listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .tint(themeManager.currentTheme.appBackgroundColor)
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, 24)
                }
                .navigationDestination(for: NavigationDestination.self) { destination in
                    destinationView(for: destination)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Settings")
                            .font(.title2)
                            .bold()
                            .foregroundColor(themeManager.currentTheme.viewTitleColor)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: NavigationDestination) -> some View {
        switch destination {
        case .themes:
            ThemeView()
        case .information:
            InformationView()
        case .privacy:
            PrivacyView()
        case .contact:
            ContactView()
            
        }
    }
}

enum NavigationDestination: Hashable {
    case themes
    case information
    case privacy
    case contact
}
struct CommonIconStyle: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .scaledToFit()
            .frame(width: 25, height: 25)
            .foregroundStyle(themeManager.currentTheme.deleteButtonColor)
    }
}

extension Image {
    func commonIconStyle() -> some View {
        self.modifier(CommonIconStyle())
    }
}
