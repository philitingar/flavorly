//
//  ThemeCardView.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//

import SwiftUI
struct ThemeCardView: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(theme.name)
                .font(.headline)
                .foregroundColor(theme.primaryTextColor)
            
            HStack(spacing: 10) {
                Circle()
                    .fill(theme.addButtonColor)
                    .frame(width: 30, height: 30)
                Circle()
                    .fill(theme.viewTitleColor)
                    .frame(width: 30, height: 30)
                Circle()
                    .fill(theme.searchButtonColor)
                    .frame(width: 30, height: 30)
                Circle()
                    .fill(theme.deleteButtonColor)
                    .frame(width: 30, height: 30)
                Circle()
                    .fill(theme.accentColor)
                    .frame(width: 30, height: 30)
                Circle()
                    .fill(theme.bottomTabButtonColorLight)
                    .frame(width: 30, height: 30)
            }
            .frame(height: 50)
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.appBackgroundColor)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? theme.addButtonColor : Color.clear, lineWidth: 3)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}
