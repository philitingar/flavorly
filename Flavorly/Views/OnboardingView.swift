//
//  OnboardingView.swift
//  Flavorly
//
//  Created by Timea Bartha on 24/1/24.
//

import SwiftUI

struct OnboardingView: View {
    var doneFunction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Text("feature.onboarding")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
                .padding()
            Text("onboarding.tags.explained")
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
            Text("onboarding.tags.alternative.usage")
                .font(.headline)
                .foregroundColor(.primary)
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
                    .background(Color.backgroundGreen)
                    .cornerRadius(12)
                    .padding()
            }
            Spacer()
        }
        .padding()
        
    }
}

