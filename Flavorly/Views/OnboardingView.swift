//
//  OnboardingView.swift
//  Flavorly
//
//  Created by Timea Bartha on 24/1/24.
//

import SwiftUI

struct OnboardingView: View {
    var doneFunction: () -> Void
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            Spacer()
            Text("feature.onboarding")
                .font(.title2)
                .bold()
                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                .padding()
            Text("onboarding.tags.explained")
                .font(.headline)
                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                .padding()
            Text("onboarding.tags.alternative.usage")
                .font(.headline)
                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                .padding()
            Spacer()
            Spacer()
            Button {
                self.doneFunction()
            } label: {
                Text("onboarding.consent")
                    .font(.headline)
                    .padding(10)
                    .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding()
            }
            Spacer()
        }
        .padding()
        
    }
}

