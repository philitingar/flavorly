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
        ZStack {
            themeManager.currentTheme.backgroundColor
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("feature.onboarding")
                    .font(.title2)
                    .bold()
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding()
                Text("onboarding.tags.explained")
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding()
                Text("onboarding.tags.alternative.usage")
                    .font(.headline)
                    .foregroundColor(themeManager.currentTheme.textColor)
                    .padding()
                Spacer()
                Spacer()
                Button {
                    self.doneFunction()
                } label: {
                    Text("onboarding.consent")
                        .font(.headline)
                        .padding(10)
                        .foregroundColor(.primary)
                        .background(.ultraThinMaterial)
                        .background(themeManager.currentTheme.addIconColor)
                        .cornerRadius(12)
                        .padding()
                }
                Spacer()
            }
            .padding()
        }
        
    }
}

