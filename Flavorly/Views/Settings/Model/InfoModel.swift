//
//  Untitled.swift
//  Flavourly
//
//  Created by Timea Bartha on 16/5/25.
//
import SwiftUI

struct InfoBoxContainer<Content: View>: View {
    @EnvironmentObject var themeManager: ThemeManager

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            content
        }
        .foregroundStyle(themeManager.currentTheme.primaryTextColor)
        .padding()
        .font(.body)
        .background(themeManager.currentTheme.textFieldBackgroundColor)
        .cornerRadius(10)
    }
}

struct InfoPoint: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(themeManager.currentTheme.addButtonColor)
                .frame(width: 30, alignment: .center)
            Text(text)
                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct InfoSubPoint: View {
    @EnvironmentObject var themeManager: ThemeManager
    let text: LocalizedStringKey
    let icon: String?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Spacer().frame(width: 30)

            if let icon = icon {
                 Image(systemName: icon)
                     .font(.body)
                     .foregroundColor(themeManager.currentTheme.addButtonColor)
                     .frame(width: 20, alignment: .center)
            } else {
                 Spacer().frame(width: 20)
            }
            Text(text)
                .foregroundColor(themeManager.currentTheme.primaryTextColor)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}


struct SectionTitle: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(themeManager.currentTheme.primaryTextColor)
            .padding(.bottom, 5)
    }
}

