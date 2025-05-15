//
//  InformationView.swift
//  Flavourly
//
//  Created by Timea Bartha on 15/5/25.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.presentationMode) var presentationMode
        @EnvironmentObject var themeManager: ThemeManager

        var body: some View {
            ZStack {
                themeManager.currentTheme.appBackgroundColor.edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        InfoBoxContainer {
                            SectionTitle("About Flavourly")
                            InfoPoint(
                                icon: "info.circle",
                                text: "Flavourly is a user-friendly app for cooking enthusiasts."
                            )
                            InfoPoint(
                                icon: "lock.shield",
                                text: "We value your privacy: no data collection."
                            )
                            InfoPoint(
                                icon: "book",
                                text: "Easily save and store your favorite recipes."
                            )
                            InfoPoint(
                                icon: "globe",
                                text: "Available in 14 different languages."
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .padding(.bottom, 50)
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Flavourly Information")
                            .foregroundColor(themeManager.currentTheme.viewTitleColor)
                            .font(.title2)
                            .bold()
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left").bold()
                                    .font(.system(size: 13))
                                    .foregroundColor(themeManager.currentTheme.addButtonColor)
                            }
                        }
                    }
                }
            }
        }
    }
