//
//  ContactView.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//
import SwiftUI

struct ContactView: View {
    @State private var showSafariView = false
    @EnvironmentObject var themeManager: ThemeManager
    let googleFormURLString = "https://forms.gle/142oXYy5vVkBzykMA"
    
    var body: some View {
        
        NavigationView {
            ZStack {
                themeManager.currentTheme.appBackgroundColor.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Group {
                            Text("Feedback & Suggestions")
                                .font(.title2)
                                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                                .fontWeight(.semibold)
                                .padding(.bottom, 5)
                            Text("If you have any questions, feedback, or notice any inaccuracies, please let us know through our contact form. Your input helps us make Flavourly better!")
                                .font(.body)
                                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                            if let url = URL(string: googleFormURLString) {
                                Button {
                                    self.showSafariView = true
                                } label: {
                                    HStack {
                                        Image(systemName: "link")
                                        Text("Open Feedback Form")
                                            .font(.body)
                                            .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .cornerRadius(10) // Rounded corners
                                    .overlay( // Overlay to add border
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(themeManager.currentTheme.secondaryTextColor, lineWidth: 1) // Border
                                    )
                                }
                                .padding()
                                
                                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                                .sheet(isPresented: $showSafariView) {
                                    SafariView(url: url)
                                }
                            } else {
                                Text("Contact form URL is invalid. Please contact support.")
                                    .font(.body)
                                    .foregroundColor(.red)
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Contact & Disclaimer")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(themeManager.currentTheme.viewTitleColor)
                        
                    }
                }
            }
        }
    }
}
