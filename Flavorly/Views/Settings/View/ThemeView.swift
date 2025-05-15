//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//

import SwiftUI
struct ThemeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text("Choose Your Color Theme")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(themeManager.currentTheme.viewTitleColor)
                    .padding(.bottom, 10)
                Divider()
                    .padding(.horizontal, 10).padding(.vertical, 0.1)
                    .overlay(themeManager.currentTheme.dividerColor)
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(themeManager.availableThemes) { theme in
                            ThemeCardView(
                                theme: theme,
                                isSelected: themeManager.currentTheme.id == theme.id,
                                action: {
                                    themeManager.selectTheme(themeId: theme.id)
                                }
                            )
                            
                        }
                        Spacer()
                    }
                    .padding()
                }
                .background(themeManager.currentTheme.appBackgroundColor.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(themeManager.currentTheme.appBackgroundColor.ignoresSafeArea())
            .padding(.top, -5)
        }
        .toolbarBackground(.hidden, for: .tabBar)
    }
}
