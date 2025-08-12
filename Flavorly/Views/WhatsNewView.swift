//
//  WhatsNewView.swift
//  Flavourly
//
//  Created by Timea Bartha on 12/8/25.
//


import SwiftUI

struct WhatsNewView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
        Text("What's new")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            Text("""
                🎉  New Sharing Feature! Now you can easily share your favorite recipes.
                💌  Send your culinary creations to friends and family with just one tap.
                📱  Perfect for meal planning, special occasions, or just spreading food love!
                """)
            .multilineTextAlignment(.leading)
            Text("""
                ✨ Keep cooking amazing things!
                🚀 Your support fuels our improvements
                """)
                .font(.caption)
                .foregroundColor(.secondary)
           
            
            Button("Got it!") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
