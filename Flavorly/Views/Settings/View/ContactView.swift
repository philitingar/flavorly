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
                            Text("feedback.suggestion")
                                .font(.title2)
                                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                                .fontWeight(.semibold)
                                .padding(.bottom, 5)
                            Text("client.question.text")
                                .font(.body)
                                .foregroundStyle(themeManager.currentTheme.primaryTextColor)
                            if let url = URL(string: googleFormURLString) {
                                Button {
                                    self.showSafariView = true
                                } label: {
                                    HStack {
                                        Image(systemName: "link")
                                        Text("open.form")
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
                                Text("contact.url.invalid")
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
                        Text("disclaimer.contact")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(themeManager.currentTheme.viewTitleColor)
                        
                    }
                }
            }
        }
    }
}
