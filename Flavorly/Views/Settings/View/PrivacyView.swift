//
//  PrivacyView.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//

import SwiftUI

struct PrivacyView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var themeManager: ThemeManager


    var body: some View {
        NavigationView {
            ZStack {
                themeManager.currentTheme.appBackgroundColor.edgesIgnoringSafeArea(.all)
                Group {
                    if let url = Bundle.main.url(forResource: "Flavourly_privacy", withExtension: "pdf") {
                        QLDocumentViewer(fileURL: url)
                            .edgesIgnoringSafeArea(.bottom)
                    } else {
                        VStack(spacing: 15) {
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Privacy Policy Not Found")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .padding()
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Privacy Policy")
                        .foregroundColor(themeManager.currentTheme.viewTitleColor)
                        .font(.title2)
                        .bold()
                }
            }
        }
    }
}
